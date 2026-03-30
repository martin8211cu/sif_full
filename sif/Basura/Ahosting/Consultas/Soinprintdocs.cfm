<!---
voy...
1. Definir tipo de formato.  Incluir campo de control NUMERODOC.
2. Definir formato de impresión, incluyendo el diseño y la imagen
  2a. Si tiene lineas de detalle, ocupa lineas de posdetalle
3. Seleccionar formato, usando 'FACT'
---->
<cfset LvarOCX			= StructNew()>
<cfset LvarOCX.clsid	= "0FC59281-AD36-4FA6-A1AE-525E7D740FCC">
<cfset LvarOCX.version	= "1.0.98">

<cfset caller.LvarOCX = LvarOCX >
<cfoutput>

<OBJECT ID="Imprime1"
		CLASSID="CLSID:#LvarOCX.clsid#" name="Prueba" version="1.0.98"
		>
		<span id="ErrorActiveX"></span>
</OBJECT>
<strong>PROBANDO...</strong>
<script language="javascript">
	function sbDownload(pObjeto)
	{
		<!---Deteccion del Navegador--->
		var BrowserDetect = {
			init: function () {
				this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
				this.version = this.searchVersion(navigator.userAgent)
					|| this.searchVersion(navigator.appVersion)
					|| "an unknown version";
				this.OS = this.searchString(this.dataOS) || "an unknown OS";
			},
			searchString: function (data) {
				for (var i=0;i<data.length;i++)	{
					var dataString = data[i].string;
					var dataProp = data[i].prop;
					this.versionSearchString = data[i].versionSearch || data[i].identity;
					if (dataString) {
						if (dataString.indexOf(data[i].subString) != -1)
							return data[i].identity;
					}
					else if (dataProp)
						return data[i].identity;
				}
			},
			searchVersion: function (dataString) {
				var index = dataString.indexOf(this.versionSearchString);
				if (index == -1) return;
				return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
			},
			dataBrowser: [
				{
					string: navigator.userAgent,
					subString: "Chrome",
					identity: "Chrome"
				},
				{ 	string: navigator.userAgent,
					subString: "OmniWeb",
					versionSearch: "OmniWeb/",
					identity: "OmniWeb"
				},
				{
					string: navigator.vendor,
					subString: "Apple",
					identity: "Safari",
					versionSearch: "Version"
				},
				{
					prop: window.opera,
					identity: "Opera"
				},
				{
					string: navigator.vendor,
					subString: "iCab",
					identity: "iCab"
				},
				{
					string: navigator.vendor,
					subString: "KDE",
					identity: "Konqueror"
				},
				{
					string: navigator.userAgent,
					subString: "Firefox",
					identity: "Firefox"
				},
				{
					string: navigator.vendor,
					subString: "Camino",
					identity: "Camino"
				},
				{		// for newer Netscapes (6+)
					string: navigator.userAgent,
					subString: "Netscape",
					identity: "Netscape"
				},
				{
					string: navigator.userAgent,
					subString: "MSIE",
					identity: "Explorer",
					versionSearch: "MSIE"
				},
				{
					string: navigator.userAgent,
					subString: "Gecko",
					identity: "Mozilla",
					versionSearch: "rv"
				},
				{ 		// for older Netscapes (4-)
					string: navigator.userAgent,
					subString: "Mozilla",
					identity: "Netscape",
					versionSearch: "Mozilla"
				}
			],
			dataOS : [
				{
					string: navigator.platform,
					subString: "Win",
					identity: "Windows"
				},
				{
					string: navigator.platform,
					subString: "Mac",
					identity: "Mac"
				},
				{
					   string: navigator.userAgent,
					   subString: "iPhone",
					   identity: "iPhone/iPod"
				},
				{
					string: navigator.platform,
					subString: "Linux",
					identity: "Linux"
				}
			]
		
		};
		BrowserDetect.init();
		var LvarOCXversion	= "";
		var LvarDebug		= "";
		if (document.getElementById(pObjeto))
		{
			LvarEstatus = "Se encuentra el Objeto Version:"+document.getElementById(pObjeto).name;
			if (document.getElementById(pObjeto).version)
				LvarOCXversion = document.getElementById(pObjeto).version;
			else
				LvarOCXversion = "0";
		}

		if (document.getElementById("ErrorActiveX"))
		{
			if (BrowserDetect.browser != "Explorer")
				LvarDebug = "Error ActiveX: El ActiveX 'soinPrintDocs.ocx' sólo puede ejecutarse en Microsoft Internet Explorer.";
			else
				LvarDebug = "Error ActiveX: Instale primero el 'soinPrintDocs.ocx'";
		}
		else if (LvarOCXversion != "<cfoutput>#LvarOCX.version#</cfoutput>")
			LvarDebug = "Error ActiveX: Se requiere reinstalar la versión '<cfoutput>#LvarOCX.version#</cfoutput>' del 'soinPrintDocs.ocx' (version instalada: '" + LvarOCXversion + "')";
		else
		{
			LvarDebug = "Error ActiveX: No hubo error";
			location.href = "SoinPrintDocs2.cfm?Browser="+BrowserDetect.browser+"&Version="+BrowserDetect.version+"&OS="+BrowserDetect.OS+"&Error="+LvarDebug+"&Estatus="+LvarEstatus;
		}

		LvarDebug += "\n";

		if (document.getElementById(pObjeto))
		{
			LvarDebug += document.getElementById(pObjeto).id + "\n";
			if (document.getElementById(pObjeto).version)
				LvarDebug += "Version=" + LvarOCXversion + "\n";
		}
		if (document.getElementById("ErrorActiveX"))
			LvarDebug += document.getElementById("ErrorActiveX").id + "\n";
		LvarDebug += "finDebug";
		<!---alert(LvarDebug);	

		alert("Instalación:\n1) Baje y abra el soinPrintDocs.zip\n2) Cierre TODAS las instancias de Internet Explorer\n3) Ejecute setup.exe\n4) Si no se pudo instalar ejecute la instalación manual");--->
			location.href = "SoinPrintDocs2.cfm?Browser="+BrowserDetect.browser+"&Version="+BrowserDetect.version+"&OS="+BrowserDetect.OS+"&Error="+LvarDebug+"&Estatus="+LvarEstatus;
	}
</script>
<script language="javascript">
	sbDownload("Imprime1");
</script>

</cfoutput>
