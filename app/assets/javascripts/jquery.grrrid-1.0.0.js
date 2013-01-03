/*	
 *	jQuery grrrid 1.0.0,
 *	
 *	Copyright (c) 2012 Fred Heusschen
 *	www.frebsite.nl
 *
 *	Plugin website:
 *	grrrid.frebsite.nl
 *
 *	Dual licensed under the MIT and GPL licenses.
 *	http://en.wikipedia.org/wiki/MIT_License
 *	http://en.wikipedia.org/wiki/GNU_General_Public_License
 */

(function($) {
	if ($.fn.grrrid) return;

	$.fn.grrrid = function( _f, _o1, _o2, _o3 ) {
		if ( this.length == 0 ) {
			debug( true, 'No element found for "' + this.selector+'".' );
			return this;
		}
		

		var $grr = this;

		if ( $grr.data( 'grr_is_grrrid' ) ) {
			$grr.trigger( 'destroy.grr' );
		}

		$grr.add( $grr.children() ).each( function() {
			$(this).data( 'grr_orgCSS', {
				'width'			: $(this).css( 'width' ),
				'height'		: $(this).css( 'height' ),
				'marginTop'		: $(this).css( 'marginTop' ),
				'marginRight'	: $(this).css( 'marginRight' ),
				'marginBottom'	: $(this).css( 'marginBottom' ),
				'marginLeft'	: $(this).css( 'marginLeft' ),
				'display'		: $(this).css( 'display' )
			});
		});


		$grr.bind_events = function() {

			var dims = grrrid_dimensions;

			//	The equalize event
			$grr.bind( 'equalize.grr', function( e, dimension, options ) {
				e.preventDefault();
				e.stopPropagation();

				//	remove equalize
				if ( typeof dimension == 'boolean' && !dimension ) {
					$(this).trigger( 'resetCss.grr' );
					return false;
				}

				//	set variables
				var opts = $.extend( true, {}, $.fn.grrrid.defaults.equalize, options );
				var largest, current, outer, inner

				//	set dimension
				if ( dimension != 'width' ) {
					dimension = 'height';
				}
				dimension = dims[ dimension ];

				//	set elements
				var $lms = ( opts.elements ) 
					? gr_getElements( opts.elements, $grr )
					: $grr;

				//	reset CSS?
				if ( opts.resetCss ) {
					$lms.trigger( 'resetCss.grr' );
				}

				//	fix inline elements
				$lms.each( function() {
					if ( $(this).css( 'display' ) == 'inline' ) {
						$(this).css( 'display', 'inline-block' );
					}
				});

				//	get largest size
				largest = 0;
				$lms.each( function() {
					current = $(this)[ dimension.outer ]();
					if ( current > largest ) {
						largest = current;
					}
				});

				//	adjust to adjust
				opts.adjust = gr_getAdjusted( largest, opts.adjust, $grr );
				if ( typeof opts.adjust == 'number' ) {
					largest = opts.adjust;
				}

				//	adjust to min / max
				opts.min = gr_getNumber( opts.min, $grr );
				opts.max = gr_getNumber( opts.max, $grr );
				if ( typeof opts.min == 'number' && largest < opts.min ) {
					largest = opts.min;
				}
				if ( typeof opts.max == 'number' && largest > opts.max ) {
					largest = opts.max;
				}

				//	set sizes
				$lms.each(function() {
					$(this)[ dimension.outer ]( largest );
				});
			});


			//	The justify event
			$grr.bind( 'justify.grr', function( e, dimension, options ) {
				e.preventDefault();
				e.stopPropagation();

				//	remove justify
				if ( typeof dimension == 'boolean' && !dimension ) {
					$(this).trigger( 'resetCss.grr' );
					return false;
				}

				$(this).data( 'grr_has_children', true );

				//	set variables
				var opts = $.extend( true, {}, $.fn.grrrid.defaults.justify, options );
				var avail, float, size, thisMargTop, thisMargBot, prevMargBot;
				var $first, $last;

				//	set dimension
				if ( dimension != 'width' ) {
					dimension = 'height';
				}
				dimension = dims[ dimension ];

				//	set elements
				var $lms = ( opts.elements ) 
					? gr_getElements( opts.elements, $(this) )
					: $(this).children();

				$first = $lms.first();
				$last = $lms.last();

				//	fix inline elements
				$lms.each( function() {
					if ( $(this).css( 'display' ) == 'inline' ) {
						$(this).css( 'display', 'inline-block' );
					}
				});

				//	reset CSS?
				if ( opts.resetCss ) {
					$(this).trigger( 'resetCss.grr' );
				}

				//	remove margins from first and last
				$first.css( dimension.margin[ 0 ], 0 );
				$last.css( dimension.margin[ 1 ], 0 );

				//	get available size
				if ( !opts.size ) {
					opts.size = $first.parent();
				}
				avail = gr_getAvailableSize( opts.size, dimension, $(this) );
				if ( typeof avail != 'number' ) {
					avail = gr_getTrueInnerSize( $first.parent(), dimension );
				}

				//	adjust to adjust
				opts.adjust = gr_getAdjusted( avail, opts.adjust, $grr );
				if ( typeof opts.adjust == 'number' ) {
					avail = opts.adjust;
				}

				//	remove margins from available
				prevMargBot = null;
				$lms.each( function() {
					thisMargTop = gr_getCssNumber( $(this), dimension.margin[ 0 ] );
					thisMargBot = gr_getCssNumber( $(this), dimension.margin[ 1 ] );
					avail -= thisMargTop;
					avail -= thisMargBot;

					//	if NOT floating, previous bottom margin and current top margin are overlapping,
					//	re-add the smalles to the available size
					if ( prevMargBot && prevMargBot > 0 ) {
						float = $(this).css( 'float' );
						if ( float != 'left' && float != 'right' ) {
							avail += ( prevMargBot < thisMargTop ) ? prevMargBot : thisMargTop;
						}
					}
					prevMargBot = thisMargBot;
				});

				//	set sizes
				size = avail / $lms.length;
				$lms.each( function() {
					$(this)[ dimension.outer ]( size );
				});
			});


			//	The grid event
			$grr.bind( 'grid.grr', function( e, horizontal, vertical, options ) {
				e.preventDefault();
				e.stopPropagation();

				//	remove grid
				if ( typeof dimension == 'boolean' && !dimension ) {
					$(this).trigger( 'resetCss.grr' );
					return false;
				}

				//	set variables
				if ( typeof horizontal != 'number' ) {
					horizontal = 'auto';
				}
				if ( typeof vertical == 'object' ) {
					if ( typeof options != 'object' ) {
						options = vertical;
					}
				}
				if ( typeof vertical != 'number' ) {
					vertical = 'auto';
				}
				if ( horizontal == 'auto' && vertical == 'auto' ) {
					return false;
				}
				var opts = $.extend( true, {}, $.fn.grrrid.defaults.grid, options );
				var sizes, dimension, size, adjusted;

				//	reset CSS?
				if ( opts.resetCss ) {
					$(this).trigger( 'resetCss.grr' );
				}

				//	fix inline elements
				if ( $(this).css( 'display' ) == 'inline' ) {
					$(this).css( 'display', 'inline-block' );
				}
				//	set sizes
				sizes = {
					'width'	: horizontal,
					'height': vertical
				};
				var $this = $(this);
				$.each( sizes, function( i, v ) {
					if ( v != 'auto' ) {
						dimension = dims[ i ];
						size = $this[ dimension.outer ]();
						size = size + v - ( size % v );

						//	adjust to adjust
						adjusted = gr_getAdjusted( size, opts.adjust, $this );
						if ( typeof opts.adjust == 'number' ) {
							size = adjusted;
						}
						
						//	adjust to min / max
						opts.min = gr_getNumber( opts.min, $this );
						opts.max = gr_getNumber( opts.max, $this );
						if ( typeof opts.min == 'number' && size < opts.min ) {
							size = opts.min;
						}
						if ( typeof opts.max == 'number' && size > opts.max ) {
							size = opts.max;
						}

						if ( size != v ) {
							$this[ dimension.outer ]( size );
						}
					}
				});
			});


			//	Reset and Destroy events

			$grr.bind( 'resetCss.grr', function( e ) {
				e.preventDefault();
				e.stopPropagation();
				$(this).css( $(this).data( 'grr_orgCSS' ) );
				if ( $(this).data( 'grr_has_children' ) ) {
					$(this).trigger( 'resetChildrenCss.grr' );
				}
			});
			$grr.bind( 'resetChildrenCss.grr', function( e ) {
				$(this).data( 'grr_has_children', false );
				$(this).children().each( function() {
					$(this).css( $(this).data( 'grr_orgCSS' ) );
				});
			});
			$grr.bind( 'destroy.grr', function( e ) {
				e.preventDefault();
				e.stopPropagation();
				$(this).trigger( 'resetCss.grr' );
				$(this).unbind( '.grr' );
				$(this).data( 'grr_is_grrrid', false );
			});
		};	//	/bind_events


		$grr.data( 'grr_is_grrrid', true );
		$grr.bind_events();

		if ( typeof _f == 'boolean' && !_f ) {
			$grr.trigger( 'resetCss.grr' );
			return false;

		} else if ( _f ) {
			switch ( _f ) {
				case 'equalize':
					$grr.first().trigger( _f + '.grr', [ _o1, _o2, _o3 ] );
					break;
				case 'justify':
				case 'grid':
					$grr.trigger( _f + '.grr', [ _o1, _o2, _o3 ] );
					break;
			}
		}

		return $grr;
	};



	//	PUBLIC

	$.fn.grrrid.defaults = {
		'equalize': {
			elements: null,
			min: null,
			max: null,
			adjust: null,
			resetCss: false
		},
		'justify': {
			elements: null,
			size: null,
			adjust: null,
			resetCss: false
		},
		'grid': {
			horizontal: null,
			vertical: null,
			min: null,
			max: null,
			adjust: null,
			resetCss: false
		}
	};



	//	PRIVATE

	var grrrid_dimensions = {
		'width': {
			'size'		: 'width',
			'outer'		: 'outerWidth',
			'inner'		: 'innerWidth',
			'padding'	: [ 'paddingLeft', 'paddingRight' ],
			'margin'	: [ 'marginLeft', 'marginRight' ],
			'border'	: [ 'borderLeftWidth', 'borderRightWidth' ],
		},
		'height': {
			'size'		: 'height',
			'outer'		: 'outerHeight',
			'inner'		: 'innerHeight',
			'padding'	: [ 'paddingTop', 'paddingBottom' ],
			'margin'	: [ 'marginTop', 'marginBottom' ],
			'border'	: [ 'borderTopWidth', 'borderBottomWidth' ]
		}
	};

	function gr_getElements( l, $gr ) {
	
		//	jquery
		if ( l instanceof $ ) {
			return l;

		//	string or dom element
		} else if ( typeof l == 'string' || l instanceof HTMLElement ) {
			return $(l);

		//	function
		} else if ( $.isFunction( l ) ) {
			var $el = $([]);
			$gr.each( function() {
				var el = l.call( this );
				if ( el ) {
					$el = $el.add( gr_getElements( el ) );
				}
			});
			return $el;

		//	array or object
		} else if ( $.isArray( l ) || typeof l == 'object'  ) {
			switch ( l.length ) {
				case 1:
					return $( gr_getElements( l[ 0 ] ) );
					break;
				default:
					var $el = $([]);
					$.each( l, function( i, v ) {
						$el = $el.add( gr_getElements( v ) );
					});
					return $el;
			}
		}

		//	no value found
		return l;
	}

	function gr_getNumber( n, $gr ) {

		//	string
		if ( typeof n == 'string' ) {
			return parseInt( n, 10 );

		//	function
		} else if (  $.isFunction( n ) ) {
			var en = n.call( $gr[ 0 ] );
			if ( en ) {
				return gr_getNumber( en, $gr );
			}
		}

		//	no value found
		return n;
	}

	function gr_getAvailableSize( s, dms, $gr ) {

		//	number
		if ( typeof s == 'number' ) {
			return s;
		}

		//	jquery
		s = gr_getElements( s, $gr );
		if ( s instanceof $ ) {
			return gr_getTrueInnerSize( s, dms );
		}

		//	string
		if ( typeof s == 'string' ) {
			return gr_getNumber( s, $gr );
		}
		
		return s;
	}

	function gr_getAdjusted( o, adj, $gr ) {

		//	string
		if ( typeof adj == 'string' ) {
			
			//	percentage
			if ( adj.substr( -1 ) == '%' ) {
				var pc = gr_getNumber( adj.substr( 0, adj.length-1 ), $gr );
				return Math.ceil( o * pc / 100 );
			}
			
			return o + gr_getNumber( adj, $gr );

		//	function
		} else if (  $.isFunction( adj ) ) {
			var ad = adj.call( $gr[ 0 ], o );
			if ( ad ) {
				return gr_getAdjusted( o, ad, $gr );
			}

		//	number
		} else if ( typeof adj == 'number' ) {
			return o + adj;
		}

		//	no value found
		return o;
	}

	function gr_getTrueInnerSize( $el, dms ) {
		var size = $el[ dms.inner ]();
		var pad0 = gr_getCssNumber( $el, dms.padding[ 0 ] );
		var pad1 = gr_getCssNumber( $el, dms.padding[ 1 ] );
		return size - ( pad0 + pad1 );
	}
	function gr_getCssNumber( $el, prop ) {
		return parseInt( $el.css( prop ) , 10 )
	}

	function debug( d, m ) {
		if ( !d ) {
			return false;
		}
		if ( typeof m == 'string' ) {
			m = 'grrrid: ' + m;
		} else {
			m = [ 'grrrid:', m ];
		}

		if ( window.console && window.console.log ) {
			window.console.log( m );
		}
		return false;
	}
	
	
	//	Override innerWidth / innerHeight methods to also use them as setters
	var _orgOuterWidth = $.fn.outerWidth;
    $.fn.outerWidth = function( size ) {
		if ( typeof size == 'number' ) {
			var outer = this.outerWidth();
			var inner = gr_getTrueInnerSize( this, grrrid_dimensions.width );
			return this.width( size - ( outer - inner ) ) ;
		}

        return _orgOuterWidth.call( this );
    };
    var _orgOuterHeight = $.fn.outerHeight;
    $.fn.outerHeight = function( size ) {
		if ( typeof size == 'number' ) {
			var outer = this.outerHeight();
			var inner = gr_getTrueInnerSize( this, grrrid_dimensions.height );
			return this.height( Math.floor( size - ( outer - inner ) ) ) ;
		}

        return _orgOuterHeight.call( this );
    };

})(jQuery);