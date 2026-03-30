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
		var form 	= document.getElementById("formRH");
		
		form.Pnombre.value = "";
		form.Papellido1.value = "";			
		form.Papellido2.value = "";
		form.Pid.value = "";
		form.Acodigo.checked = false;
		form.EEcodigo.checked = false;
		form.Splaza.checked = false;
		form.Dcodigo.checked = false;
		form.Pnacimiento.value = "";
		form.Pdireccion.value = "";
		form.Pcasa.value = "";
		form.Pemail1.value = "";
		form.Pemail2.value = "";
		inicio();
	}
//------------------------------------------------------------------------------------------			
	function inicio(){
		var varDcodigo 	= document.getElementById("Dcodigo");
			
		Nivel(varDcodigo);
	}	
	
//------------------------------------------------------------------------------------------			
	function Nivel(obj){
		var connVerNiveles 	= document.getElementById("verNiveles");
	
		if(obj.checked) {
			connVerNiveles.style.display = "";
			if (obj.form.Ncodigo) {
				obj.form.Ncodigo.disabled = false;
			}
		} else {
			connVerNiveles.style.display = "none";
			if (obj.form.Ncodigo) {
				obj.form.Ncodigo.disabled = true;
			}
		}
		if (obj.form.Ncodigo) {
			objForm.Ncodigo.required = (!obj.form.Ncodigo.disabled);
		}
	}	
//------------------------------------------------------------------------------------------