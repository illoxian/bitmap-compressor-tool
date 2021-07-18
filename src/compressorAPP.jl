using Images: ImageShow
using Gtk: Window
using FileIO: action, open
using FileIO: action, save
using FileIO
using ImageIO
using Images
using ImageView

using Colors
using ImageMagick

using Gtk
using Gtk.ShortNames, GtkReactive

using LinearAlgebra
using FFTW
using ColorTypes
using Colors


include("bmpCompressor.jl")

# inFilePath = ARGS[1]
# d = ARGS[2]
# f = ARGS[3]
# outFilePath = inFilePath * "_" * d * "_" * f * ".bmp"
f_value = 0
d_value = 0
global file_global = ""




# Put your GUI code here

win = GtkWindow("BMP Compressor Tool", 300, 150)
vbox = GtkBox(:v)
push!(win, vbox)


f_text = GtkLabel("F value")
f_entry = GtkSpinButton(0,1000,1)
d_text = GtkLabel("D value")
d_entry = GtkSpinButton(0,1998,1)
filebox = GtkBox(:v)
file_text = GtkLabel("Choose a BMP file")

# file_entry = GtkFileChooserDialog(:action, open)
# set_gtk_property!(file_entry, :action, open)
choose_file = GtkButton("Pick a FIle")

compress_button = GtkButton("Compress")


push!(vbox, f_text)
push!(vbox, f_entry)
push!(vbox, d_text)
push!(vbox, d_entry)
push!(vbox, filebox)

push!(filebox,file_text)
push!(filebox, choose_file)

push!(vbox,compress_button)

showall(win)

function on_button_clicked(w)
    f_value = get_gtk_property(f_entry,:value,Int)
    d_value = get_gtk_property(d_entry,:value,Int)
    file = file_global
    #check f and d value
    # filename = get_gtk_property(file_entry, :filename, String)
    println("test")
    println("clicked  ", f_value, " and ", d_value)
    println(file)
    if (((2*f_value)-2) < d_value )
        println("Error!")
        errwin = GtkWindow("ERROR", 10, 5)
        box = GtkBox(:v)
        err = GtkLabel("D must be <= 2F-2")
        push!(box, err)
        push!(errwin, box) 
        showall(errwin)


        
    else
        compressedImage = compress(file, f_value, d_value)
            # qui ho image out compressa
        imagestd = load(file)
        println("ok compressed")
    
    
    # VERSION1
        imshow(imagestd, name="Original")
        imshow(compressedImage, name = "Compressed")
    end


    # gui = imshow_gui((300, 300), (2, 1), name="Comparator")  # 2 columns, 1 row of images (each initially 300×300)
    # canvases = gui["canvas"]

    # im1 = Signal(imagestd[:,:,1])
    # im2 = Singal(compressedImage[:,:,1])

    # showall(gui["window"])

    # imshow(canvases[1, 1], im1)
    # imshow(canvases[1, 2], im2)

    # push!(im1, imagestd[:,:,1] )
    # push!(im2, compressedImage[:,:,1])






end


function on_choose_button_clicked(w)
    global file_global = open_dialog("Pick a BMP file", win, ("*.bmp",))
    println(file_global)

end


signal_connect(on_button_clicked, compress_button, "clicked")
signal_connect(on_choose_button_clicked, choose_file, "clicked")


if !isinteractive()
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    @async Gtk.gtk_main()
    wait(c)
end

 
