// ==================================================================================================
// 								Usadas para conlis de fecha
// ==================================================================================================

	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
// ==================================================================================================
// ==================================================================================================	
//------------------------------------------------------------------------------------------
	function limpiar(){
		var form 	= document.getElementById("formAlumno");
		
		form.Pnombre.value = "";
		form.Papellido1.value = "";			
		form.Papellido2.value = "";
		form.Pid.value = "";
		form.Pnacimiento.value = "";
		form.Pdireccion.value = "";
		form.Pcasa.value = "";
		//form.Poficina.value = "";
		//form.Pcelular.value = "";
		//form.Pfax.value = "";
		//form.Ppagertel.value = ""; 
		//form.Ppagernum.value = "";
		form.Pemail1.value = "";
		form.Pemail2.value = "";
	}
//------------------------------------------------------------------------------------------
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

//------------------------------------------------------------------------------------------