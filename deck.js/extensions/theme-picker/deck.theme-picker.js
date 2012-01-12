$(function() {
	
	$('.deck-container').prepend('<div class="theme-picker"><h2>Themes</h2><label for="style-themes">Style:</label><select id="style-themes"><option selected="selected" value="deck.js/themes/style/web-2.0.css">Web 2.0</option><option value="deck.js/themes/style/swiss.css">Swiss</option><option value="deck.js/themes/style/neon.css">Neon</option><option value="">None</option></select><label for="transition-themes">Transition:</label><select id="transition-themes"><option value="deck.js/themes/transition/horizontal-slide.css">Horizontal Slide</option><option value="deck.js/themes/transition/vertical-slide.css">Vertical Slide</option><option value="deck.js/themes/transition/fade.css">Fade</option><option selected="selected" value="">None</option></select></div>');
	
	$('#style-themes').change(function() {
		$('#style-theme-link').attr('href', $(this).val());
	});
	
	$('#transition-themes').change(function() {
		$('#transition-theme-link').attr('href', $(this).val());
	});
});

