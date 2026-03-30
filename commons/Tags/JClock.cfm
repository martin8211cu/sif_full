<cfif isdefined('url.func') and url.func EQ 'GetSeg'>
	<cfoutput>#DatePart('s',NOW())#</cfoutput>
<cfelseif isdefined('url.func') and url.func EQ 'GetHor'>
	<cfoutput>#DatePart('h',NOW())#</cfoutput>
<cfelseif isdefined('url.func') and url.func EQ 'GetMin'>
	<cfoutput>#DatePart('n',NOW())#</cfoutput>
<cfelse>
	<cf_importJQuery rotate="true">
	<cfset width  = 270>
	<cfset height = 300>

	<style type="text/css">
		#clock {position: relative;
				width:  <cfoutput>#width#px</cfoutput>;
				height: <cfoutput>#height#px</cfoutput>;
				margin: 20px auto 0 auto;
				background: url(/cfmx/commons/Imagenes/clockface.png);
				list-style: none;}
		#sec, #min, #hour {position: absolute;
							width: 15px;
							height: 300px;
							top: -0;
							left: 141px;}
	
		#sec {background: url(/cfmx/commons/Imagenes/sechand.png);
			  z-index: 3;}
		#min {background: url(/cfmx/commons/Imagenes/minhand.png);
			  z-index: 2;}
		#hour {background: url(/cfmx/commons/Imagenes/hourhand.png);
				z-index: 1;}
	</style>

	<script type="text/javascript">
	 $(document).ready(function() {
              //SEGUNDOS
              setInterval( function() {
				  $.get('/cfmx/commons/Tags/JClock.cfm?func=GetSeg', function (Segundos) {
					   $('#sec').rotate({ angle : $.trim(Segundos) * 6 });
				  });
         		}, 1000 );
				
              //HORAS
              setInterval( function() {
			 	 $.get('/cfmx/commons/Tags/JClock.cfm?func=GetHor', function (Horas) {
				 	 $.get('/cfmx/commons/Tags/JClock.cfm?func=GetMin', function (Minutos) {
						 $('#hour').rotate({ angle : $.trim(Horas) * 30 + ($.trim(Minutos) / 2) });
					 });
			 	  });
			  }, 1000 );
        
              //MINUTOS
              setInterval( function() {
			  	 $.get('/cfmx/commons/Tags/JClock.cfm?func=GetMin', function (Minutos) {
					  $('#min').rotate({ angle : $.trim(Minutos) * 6 });
				  });
              }, 1000 );
        }); 
	</script>
	<ul id="clock">	
		<li id="sec"></li>
		<li id="hour"></li>
		<li id="min"></li>
	</ul>
</cfif>