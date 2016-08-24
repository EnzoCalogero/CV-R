(function($) {
    $(document).ready(function() {
	
	$('#custom_plot').scianimator({
	    'images': ['images/custom_plot1.png', 'images/custom_plot2.png', 'images/custom_plot3.png', 'images/custom_plot4.png', 'images/custom_plot5.png'],
	    'width': 480,
	    'delay': 200,
	    'loopMode': 'loop'
	});
	$('#custom_plot').scianimator('play');
    });
})(jQuery);
