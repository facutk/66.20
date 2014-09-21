var res = "320x240";
var z = 4;
var zFactor = 1.5;
var c_re = 0;
var c_im = 0; 

$(document).ready(function(){
    $( "#mandelmap" ).on( "click", function(e) {
        if( e.offsetX==undefined ) {
            xpos = e.pageX-$('#mandelmap').offset().left;
            ypos = e.pageY-$('#mandelmap').offset().top;
        }
        else {
            xpos = e.offsetX;
            ypos = e.offsetY;
        }
        if(!this.canvas) {
            this.canvas = $('<canvas />')[0];
            this.canvas.width = this.width;
            this.canvas.height = this.height;
            this.canvas.getContext('2d').drawImage(this, 0, 0, 
            this.width, this.height);
        }
        
        c_re = ( xpos*( z / this.width ) + ( c_re - (z / 2) ) );
        c_im = ( ( c_im + (z / 2) ) - z*( ypos / this.height ) );
        c_im_sign = ( c_im < 0 )? '':'+';
        z = z / zFactor;
        
        $("#mandelmap").attr(
            "src",
            "http://localhost:5000/mandelbrot.gif" +
            "?" +
            "res=" + res +
            "&w=" + z +
            "&h=" + z +// );
            "&center=" + c_re + c_im_sign + c_im + "i" );
        });
});
