// JavaScript Document

	//initial time
	var h_current = -1;
	var m1_current = -1;
	var m2_current = -1;
	var s1_current = -1;
	var s2_current= -1;

	
	function flip (upperId, lowerId, changeNumber, pathUpper, pathLower){
		var upperBackId = upperId+"Back";
		$(upperId).src = $(upperBackId).src;
		$(upperId).setStyle("height", "55px");
		$(upperId).setStyle("visibility", "visible");
		$(upperBackId).src = pathUpper+parseInt(changeNumber)+".png";
		
		$(lowerId).src = pathLower+parseInt(changeNumber)+".png";
		$(lowerId).setStyle("height", "0px");
		$(lowerId).setStyle("visibility", "visible");
		
		var flipUpper = new Fx.Tween(upperId, {duration: 200, transition: Fx.Transitions.Sine.easeInOut});
		flipUpper.addEvents({
			'complete': function(){
				var flipLower = new Fx.Tween(lowerId, {duration: 200, transition: Fx.Transitions.Sine.easeInOut});
					flipLower.addEvents({
						'complete': function(){	
							lowerBackId = lowerId+"Back";
							$(lowerBackId).src = $(lowerId).src;
							$(lowerId).setStyle("visibility", "hidden");
							$(upperId).setStyle("visibility", "hidden");
						}				});					
					flipLower.start('height', 55);
					
			}
							});
		flipUpper.start('height', 0);
		
		
	}//flip
			

	
	function retroClock(fecha){
		
		// get new time
		 now = fecha;
		 h = now.getHours();
		 m1 = now.getMinutes() / 10;
		 m2 = now.getMinutes() % 10;
		 s1 = now.getSeconds() / 10;
		 s2 = now.getSeconds() % 10;
		 if(h < 12)
		 	ap = "AM";
		 else{ 
		 	if( h == 12 )
				ap = "PM";
			else{
				ap = "PM";
				h -= 12; }
		 }
		 
		 //change pads
		 
		 if( h != h_current){
			flip('hoursUp', 'hoursDown', h, '/cfmx/commons/Imagenes/Single/Up/'+ap+'/', '/cfmx/commons/Imagenes/Single/Down/'+ap+'/');
			h_current = h;
		}
		
		if( m2 != m2_current){
			flip('minutesUpRight', 'minutesDownRight', m2, '/cfmx/commons/Imagenes/Double/Up/Right/', '/cfmx/commons/Imagenes/Double/Down/Right/');
			m2_current = m2;
			
			flip('minutesUpLeft', 'minutesDownLeft', m1, '/cfmx/commons/Imagenes/Double/Up/Left/', '/cfmx/commons/Imagenes/Double/Down/Left/');
			m1_current = m1;
		}
		
		 if (s2 != s2_current){
			flip('secondsUpRight', 'secondsDownRight', s2, '/cfmx/commons/Imagenes/Double/Up/Right/', '/cfmx/commons/Imagenes/Double/Down/Right/');
			s2_current = s2;
			
			flip('secondsUpLeft', 'secondsDownLeft', s1, '/cfmx/commons/Imagenes/Double/Up/Left/', '/cfmx/commons/Imagenes/Double/Down/Left/');
			s1_current = s1;
		}
		
		
		
			
		
	}
			
	