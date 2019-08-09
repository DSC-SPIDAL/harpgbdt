"""
===========================
Creating annotated heatmaps
===========================

It is often desirable to show data which depends on two independent
variables as a color coded image plot. This is often referred to as a
heatmap. If the data is categorical, this would be called a categorical
heatmap.
Matplotlib's :meth:`imshow <matplotlib.axes.Axes.imshow>` function makes
production of such plots particularly easy.

The following examples show how to create a heatmap with annotations.
We will start with an easy example and expand it to be usable as a
universal function.
"""


##############################################################################
#
# A simple categorical heatmap
# ----------------------------
#
# We may start by defining some data. What we need is a 2D list or array
# which defines the data to color code. We then also need two lists or arrays
# of categories; of course the number of elements in those lists
# need to match the data along the respective axes.
# The heatmap itself is an :meth:`imshow <matplotlib.axes.Axes.imshow>` plot
# with the labels set to the categories we have.
# Note that it is important to set both, the tick locations
# (:meth:`set_xticks<matplotlib.axes.Axes.set_xticks>`) as well as the
# tick labels (:meth:`set_xticklabels<matplotlib.axes.Axes.set_xticklabels>`),
# otherwise they would become out of sync. The locations are just
# the ascending integer numbers, while the ticklabels are the labels to show.
# Finally we can label the data itself by creating a
# :class:`~matplotlib.text.Text` within each cell showing the value of
# that cell.

import sys
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
# sphinx_gallery_thumbnail_number = 2


class PlotConfigure():
    #dataroot='/tmp/hpda/test/expresult/'
    dataroot='/tmp/hpda/test/experiments/results/'
    params ={\
        'backend': 'GTKAgg',
        
        #'font.fontname':'Calibri',
        #'font.weight': 900,
#'font.weight': 'bold',
        'font.family': 'serif',
        'font.serif': ['Times New Roman', 'FreeSerif', 'Palatino', 'New Century Schoolbook', 'Bookman', 'Computer Modern Roman'],
        #'font.serif': ['Bitstream Vera Serif', 'Palatino', 'New Century Schoolbook', 'Bookman', 'Computer Modern Roman'],
        #'font.size': 10,
        #'font.sans-serif' : ['Helvetica', 'Avant Garde', 'Computer Modern Sans serif'],
        #font.cursive       : Zapf Chancery
        #font.monospace     : Courier, Computer Modern Typewriter
        'text.usetex': False,
        
#'axes.labelsize': 12,
#        'axes.linewidth': .75,
        
        #'figure.figsize': (8,6),
        'figure.figsize': (4.50,4.80),
#        'figure.subplot.left' : 0.175,
#        'figure.subplot.right': 0.95,
#        'figure.subplot.bottom': 0.15,
#        'figure.subplot.top': .95,
        
        'figure.dpi':300,
        
        # 'text.fontsize': 5,
        #'text.fontsize': 5,
        'legend.fontsize': 14,
        'xtick.labelsize': 12,
        'ytick.labelsize': 12,
        
        'axes.labelsize': 14,
        'axes.labelweight': 'bold',

#        'lines.linewidth':1.25,
#        'lines.markersize'  : 4,
#        'lines.markeredgewidth': 0.1,
        'savefig.dpi':600,
        }
    
    def draw_init(self):
        plt.rcParams.update(self.params)
#if not os.path.exists(self.dataroot):
#            print('ERROR: dataroot not found at %s'%self.dataroot)
#            sys.exit(-1)

vegetables = ["cucumber", "tomato", "lettuce", "asparagus",
              "potato", "wheat", "barley"]
farmers = ["Farmer Joe", "Upland Bros.", "Smith Gardening",
           "Agrifun", "Organiculture", "BioGoods Ltd.", "Cornylee Corp."]

harvest = np.array([[0.8, 2.4, 2.5, 3.9, 0.0, 4.0, 0.0],
                    [2.4, 0.0, 4.0, 1.0, 2.7, 0.0, 0.0],
                    [1.1, 2.4, 0.8, 4.3, 1.9, 4.4, 0.0],
                    [0.6, 0.0, 0.3, 0.0, 3.1, 0.0, 0.0],
                    [0.7, 1.7, 0.6, 2.6, 2.2, 6.2, 0.0],
                    [1.3, 1.2, 0.0, 0.0, 0.0, 3.2, 5.1],
                    [0.1, 2.0, 0.0, 1.4, 0.0, 1.9, 6.3]])


#fig, ax = plt.subplots()
#im = ax.imshow(harvest)
#
## We want to show all ticks...
#ax.set_xticks(np.arange(len(farmers)))
#ax.set_yticks(np.arange(len(vegetables)))
## ... and label them with the respective list entries
#ax.set_xticklabels(farmers)
#ax.set_yticklabels(vegetables)
#
## Rotate the tick labels and set their alignment.
#plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
#         rotation_mode="anchor")
#
## Loop over data dimensions and create text annotations.
#for i in range(len(vegetables)):
#    for j in range(len(farmers)):
#        text = ax.text(j, i, harvest[i, j],
#                       ha="center", va="center", color="w")
#
#ax.set_title("Harvest of local farmers (in tons/year)")
#fig.tight_layout()
#plt.show()
#

#############################################################################
# Using the helper function code style
# ------------------------------------
#
# As discussed in the :ref:`Coding styles <coding_styles>`
# one might want to reuse such code to create some kind of heatmap
# for different input data and/or on different axes.
# We create a function that takes the data and the row and column labels as
# input, and allows arguments that are used to customize the plot
#
# Here, in addition to the above we also want to create a colorbar and
# position the labels above of the heatmap instead of below it.
# The annotations shall get different colors depending on a threshold
# for better contrast against the pixel color.
# Finally, we turn the surrounding axes spines off and create
# a grid of white lines to separate the cells.


def heatmap(data, row_labels, col_labels, xlabel, ylabel,
            ax=None,
            cbar_kw={}, cbarlabel="", **kwargs):
    """
    Create a heatmap from a numpy array and two lists of labels.

    Arguments:
        data       : A 2D numpy array of shape (N,M)
        row_labels : A list or array of length N with the labels
                     for the rows
        col_labels : A list or array of length M with the labels
                     for the columns
    Optional arguments:
        ax         : A matplotlib.axes.Axes instance to which the heatmap
                     is plotted. If not provided, use current axes or
                     create a new one.
        cbar_kw    : A dictionary with arguments to
                     :meth:`matplotlib.Figure.colorbar`.
        cbarlabel  : The label for the colorbar
    All other arguments are directly passed on to the imshow call.
    """

    if not ax:
        ax = plt.gca()

    # Plot the heatmap
    im = ax.imshow(data, **kwargs)

    # Create colorbar
    cbar = ax.figure.colorbar(im, ax=ax, **cbar_kw)
    cbar.ax.set_ylabel(cbarlabel, rotation=-90, va="bottom", fontweight='bold')

    # We want to show all ticks...
    ax.set_xticks(np.arange(data.shape[1]))
    ax.set_yticks(np.arange(data.shape[0]))
    # ... and label them with the respective list entries.
    ax.set_xticklabels(col_labels)
    ax.set_yticklabels(row_labels)

    # Let the horizontal axes labeling appear on top.
    ax.tick_params(top=True, bottom=False,
                   labeltop=True, labelbottom=False)

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=-30, ha="right",
             rotation_mode="anchor")

    # Turn spines off and create white grid.
    for edge, spine in ax.spines.items():
        spine.set_visible(False)

    ax.set_xticks(np.arange(data.shape[1]+1)-.5, minor=True)
    ax.set_yticks(np.arange(data.shape[0]+1)-.5, minor=True)
    ax.grid(which="minor", color="w", linestyle='-', linewidth=3)
    ax.tick_params(which="minor", bottom=False, left=False)

    #x,y label
    ax.set_xlabel(xlabel, fontweight='bold')
    ax.set_ylabel(ylabel, fontweight='bold')



    return im, cbar


def annotate_heatmap(im, data=None, valfmt="{x:.2f}",
                     textcolors=["black", "white"],
                     threshold=None, **textkw):
    """
    A function to annotate a heatmap.

    Arguments:
        im         : The AxesImage to be labeled.
    Optional arguments:
        data       : Data used to annotate. If None, the image's data is used.
        valfmt     : The format of the annotations inside the heatmap.
                     This should either use the string format method, e.g.
                     "$ {x:.2f}", or be a :class:`matplotlib.ticker.Formatter`.
        textcolors : A list or array of two color specifications. The first is
                     used for values below a threshold, the second for those
                     above.
        threshold  : Value in data units according to which the colors from
                     textcolors are applied. If None (the default) uses the
                     middle of the colormap as separation.

    Further arguments are passed on to the created text labels.
    """

    if not isinstance(data, (list, np.ndarray)):
        data = im.get_array()

    # Normalize the threshold to the images color range.
    if threshold is not None:
        threshold = im.norm(threshold)
    else:
        threshold = im.norm(data.max())/2.

    # Set default alignment to center, but allow it to be
    # overwritten by textkw.
    kw = dict(horizontalalignment="center",
              verticalalignment="center",
              fontsize=16)
    kw.update(textkw)

    # Get the formatter in case a string is supplied
    if isinstance(valfmt, str):
        valfmt = matplotlib.ticker.StrMethodFormatter(valfmt)

    # Loop over the data and create a `Text` for each "pixel".
    # Change the text's color depending on the data.
    texts = []
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            kw.update(color=textcolors[im.norm(data[i, j]) > threshold])
            text = im.axes.text(j, i, valfmt(data[i, j], None),  **kw)
            texts.append(text)

    return texts


##########################################################################
# The above now allows us to keep the actual plot creation pretty compact.
#

#fig, ax = plt.subplots()
#
#im, cbar = heatmap(harvest, vegetables, farmers, ax=ax,
#                   cmap="YlGn", cbarlabel="harvest [t/year]")
#texts = annotate_heatmap(im, valfmt="{x:.1f} t")
#
#fig.tight_layout()
#plt.show()
#fig, ax = plt.subplots(1,1, figsize=(8,6))
#fig, ax = plt.subplots(1,1, figsize=(4,3))

def draw_depth():
    ftsize=[1,4,8,16,32,64,128]
    blksize=[1,4,8,16,32,64,128,256]
    
    data = np.loadtxt('synset-d8-depth.txt') 
    dp0 = data[:,0].reshape((len(ftsize), len(blksize)))
    dp1 = data[:,1].reshape((len(ftsize), len(blksize)))
    
    x = ["{}".format(i) for i in ftsize]
    y = ["{}".format(i) for i in blksize]
    
    fig, ax = plt.subplots()
    im, _ = heatmap(dp0, x, y, 'Node Block Size', 'Feature Block Size',
                    ax=ax, vmin=0, vmax=3,
                    cmap="coolwarm", cbarlabel="Speedup of Training Time")
    annotate_heatmap(im, valfmt="{x:.2f}", threshold=1.0,
                     textcolors=["black", "white"])
    plt.tight_layout()
    #plt.show()
    plt.savefig('synset-d8-depth-dp0.pdf')
    
    fig, ax = plt.subplots()
    im, _ = heatmap(dp1, x, y, 'Node Block Size', 'Feature Block Size',
                    ax=ax, vmin=0,vmax=3,
                    cmap="coolwarm", cbarlabel="Speedup of Training Time")
    annotate_heatmap(im, valfmt="{x:.2f}", threshold=1.0,
                     textcolors=["black", "white"])
    plt.tight_layout()
    #plt.show()
    plt.savefig('synset-d8-depth-dp1.pdf')
    


def draw_lossguide(fname):
    ftsize=[1,4,8,16,32,64,128]
    blksize=[1,4,8,16,32]
    
    data = np.loadtxt(fname + '.txt') 
    dp0 = data[:,0].reshape((len(ftsize), len(blksize)))
    dp1 = data[:,1].reshape((len(ftsize), len(blksize)))
    
    x = ["{}".format(i) for i in ftsize]
    y = ["{}".format(i) for i in blksize]
    
    fig, ax = plt.subplots()
    im, _ = heatmap(dp0, x, y, 'Node Block Size', 'Feature Block Size',
                    ax=ax, vmin=0,vmax=3,
                    cmap="coolwarm", cbarlabel="Speedup of Training Time")
    annotate_heatmap(im, valfmt="{x:.2f}", threshold=1.0,
                     textcolors=["black", "white"])
    plt.tight_layout()
    #plt.show()
    plt.savefig(fname + '-dp0.pdf')
    
    fig, ax = plt.subplots()
    im, _ = heatmap(dp1, x, y, 'Node Block Size', 'Feature Block Size',
                    ax=ax, vmin=0,vmax=3,
                    cmap="coolwarm", cbarlabel="Speedup of Training Time")
    annotate_heatmap(im, valfmt="{x:.2f}", threshold=1.0,
                     textcolors=["black", "white"])
    plt.tight_layout()
    #plt.show()
    plt.savefig(fname + '-dp1.pdf')
 

if __name__ == "__main__":

    if len(sys.argv) < 2:
        print('usage: make-heatmap.py <filename>')
        print('     filename.txt: dp0 dp1 two colum ratio txt ')
        sys.exit(0)

    plotconf=PlotConfigure()
    plotconf.draw_init()

    draw_lossguide(sys.argv[1])


