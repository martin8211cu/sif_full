<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/cfmx/commons/css/DigitalClockStyle.css" />
</head>

<body>

<div id="wrapper">  
	<div id="back">
         <div id="upperHalfBack">
         		<img src="/cfmx/commons/Imagenes/spacer.png" /><img id="hoursUpBack" src="/cfmx/commons/Imagenes/Single/Up/AM/0.png"/>
                <img id="minutesUpLeftBack" src="/cfmx/commons/Imagenes/Double/Up/Left/0.png" class="asd" /><img id="minutesUpRightBack" src="/cfmx/commons/Imagenes/Double/Up/Right/0.png"/>
                <img id="secondsUpLeftBack" src="/cfmx/commons/Imagenes/Double/Up/Left/0.png" /><img id="secondsUpRightBack" src="/cfmx/commons/Imagenes/Double/Up/Right/0.png"/>
         </div>
         <div id="lowerHalfBack">
         		<img src="/cfmx/commons/Imagenes/spacer.png" /><img id="hoursDownBack" src="/cfmx/commons/Imagenes/Single/Down/AM/0.png" />
               <img id="minutesDownLeftBack" src="/cfmx/commons/Imagenes/Double/Down/Left/0.png" /><img id="minutesDownRightBack" src="/cfmx/commons/Imagenes/Double/Down/Right/0.png" />
               <img id="secondsDownLeftBack" src="/cfmx/commons/Imagenes/Double/Down/Left/0.png" /><img id="secondsDownRightBack" src="/cfmx/commons/Imagenes/Double/Down/Right/0.png" />
         </div>
	</div>
    
    
    <div id="front">
         <div id="upperHalf">
         		<img src="/cfmx/commons/Imagenes/spacer.png" /><img id="hoursUp" src="/cfmx/commons/Imagenes/Single/Up/AM/0.png"/>
                <img id="minutesUpLeft" src="/cfmx/commons/Imagenes/Double/Up/Left/0.png" /><img id="minutesUpRight" src="/cfmx/commons/Imagenes/Double/Up/Right/0.png"/>
                <img id="secondsUpLeft" src="/cfmx/commons/Imagenes/Double/Up/Left/0.png" /><img id="secondsUpRight" src="/cfmx/commons/Imagenes/Double/Up/Right/0.png"/>
         </div>
         <div id="lowerHalf">
         		<img src="/cfmx/commons/Imagenes/spacer.png" /><img id="hoursDown" src="/cfmx/commons/Imagenes/Single/Down/AM/0.png"/>
               <img id="minutesDownLeft" src="/cfmx/commons/Imagenes/Double/Down/Left/0.png" /><img id="minutesDownRight" src="/cfmx/commons/Imagenes/Double/Down/Right/0.png" />
               <img id="secondsDownLeft" src="/cfmx/commons/Imagenes/Double/Down/Left/0.png" /><img id="secondsDownRight" src="/cfmx/commons/Imagenes/Double/Down/Right/0.png" />
         </div>
	</div>
	
   <div id="fecha" class="fecha"></div>
</div>
	
	<cfquery datasource="#session.dsn#" name="getHora">
	select <cf_dbfunction name="now"> as valor from dual
	</cfquery>
	
	
	<script src="/cfmx/commons/js/mootools.js" type="text/javascript"></script>
	<script src="/cfmx/commons/js/animate.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	
		var miFecha=<cfoutput>#jsDateFormat(getHora.valor)#</cfoutput>
		
		<cfscript>
		function jsDateFormat(date){
			if( isDate(date))    return 'new Date(#year(date)#,
		#(month(date)-1)#, #day(date)#, #hour(date)#, #minute(date)#,
		#second(date)#)';
			else return "null";
		}
		</cfscript>
		
	
	   function getTiempo(){	   
		   retroClock(miFecha);
		   printFecha(miFecha)
		   miFecha.setSeconds(miFecha.getSeconds()+1);
	   }
	   
	   function printFecha(miFecha){
		var fechaString="";
		fechaString =fechaString + getDiaSemana(miFecha)+' '+miFecha.getDate()+' de '+getMes(miFecha)+' del '+miFecha.getFullYear();
		document.getElementById("fecha").innerHTML=fechaString; 
	   }
	   
	   function getMes(fecha){
		var weekday=new Array(12);
		weekday[0]="Enero";
		weekday[1]="Febrero";
		weekday[2]="Marzo";
		weekday[3]="Abril";
		weekday[4]="Mayo";
		weekday[5]="Junio";
		weekday[6]="Julio";
		weekday[7]="Agosto";
		weekday[8]="Setiembre";
		weekday[9]="Octubre";
		weekday[10]="Noviembre";
		weekday[11]="Diciembre";
		return weekday[fecha.getMonth()];
	   }
	   
	   function getDiaSemana(fecha){
		var weekday=new Array(7);
		weekday[0]="Domingo";
		weekday[1]="Lunes";
		weekday[2]="Martes";
		weekday[3]="Mi\xE9rcoles";
		weekday[4]="Jueves";
		weekday[5]="Viernes";
		weekday[6]="S\xE1bado";
		return weekday[fecha.getDay()];
	   }
	   window.setInterval("getTiempo()", 1000);
	   
	   getTiempo();
	</script>	

</html>
