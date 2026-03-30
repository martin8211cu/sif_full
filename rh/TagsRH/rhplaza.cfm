<cfset def = QueryNew('RHPid')>


<!--- Parámetros del TAG --->
<!--- Parámetros Generales --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la Conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del Form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- Consulta por Defecto --->
<cfparam name="Attributes.frame" default="frplaza" type="string"> <!--- Nombre del Frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- Tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- Tamaño del objeto de la Desripcion --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Se utiliza cuando se quiere colocar varios tags en la misma pantalla --->
<cfparam name="Attributes.Ecodigo" default="#Session.Ecodigo#" type="numeric">
<!--- Nombres de los campos Dependientes --->
<cfparam name="Attributes.Dcodigo" default="Dcodigo" type="string"> <!--- Nombre del Objeto Dcodigo --->
<cfparam name="Attributes.Ocodigo" default="Ocodigo" type="string"> <!--- Nombre del Objeto Ocodigo --->
<cfparam name="Attributes.RHPpuesto" default="RHPpuesto" type="string"> <!--- Nombre del Objeto RHPpuesto --->
<!--- Nombres de los campos --->
<cfparam name="Attributes.RHPcodigo" default="RHPcodigo" type="string"> <!--- Nombre del Objeto RHPcodigo --->
<cfparam name="Attributes.RHPdescripcion" default="RHPdescripcion" type="string"> <!--- Nombre del Objeto RHPdescripcion --->
<cfparam name="Attributes.RHPid" default="RHPid" type="string"> <!--- Nombre del Objeto RHPid --->
<cfparam name="Attributes.NoCheckPlazaOcupada" default="0" type="numeric"> <!--- Chequear si una plaza está ocupada, 0 = Chequear Plaza Ocupada, 1 = No Chequear Plaza Ocupada --->
<cfparam name="Attributes.fechaAccion" default="01/01/1900" type="string"> <!--- Fecha de Accion, utilizada para el chequeo del porcentaje de la plaza --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#index#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}

	function ClearPlaza<cfoutput>#index#</cfoutput>() {
		<cfoutput>
		document.#Attributes.form#.#Attributes.RHPid#.value = "";
		document.#Attributes.form#.#Attributes.RHPcodigo#.value = "";
		document.#Attributes.form#.#Attributes.RHPdescripcion#.value = "";
		</cfoutput>
	}

	function doConlisPlaza<cfoutput>#index#</cfoutput>() {
		var params = "";
		<cfoutput>
		if (document.#Attributes.form#.#Attributes.Dcodigo#.value.replace(" ", "") != "" && document.#Attributes.form#.#Attributes.Ocodigo#.value.replace(" ", "") != "" && document.#Attributes.form#.#Attributes.RHPpuesto#.value.replace(" ", "") != "") {
			params+= "?form=#Attributes.form#&conexion=#Attributes.conexion#";
			params+= "&atrRHPcodigo=#Attributes.RHPcodigo#&atrRHPdescripcion=#Attributes.RHPdescripcion#&atrRHPid=#Attributes.RHPid#";
			params+= "&RHPpuesto=" + document.#Attributes.form#.#Attributes.RHPpuesto#.value;
			params+= "&Dcodigo=" + document.#Attributes.form#.#Attributes.Dcodigo#.value;
			params+= "&Ocodigo=" + document.#Attributes.form#.#Attributes.Ocodigo#.value;
			params+= "&empresa=#Attributes.Ecodigo#";
			params+= "&vfyplz=#Attributes.NoCheckPlazaOcupada#";
			params+= "&fechaAcc=#Attributes.fechaAccion#";
			popUpWindow#index#("/cfmx/rh/Utiles/ConlisPlaza.cfm"+params,250,200,650,400);
		} else {
			alert("Debe seleccionar un valor para Departamento, Oficina y Puesto antes de escoger la Plaza");
			ClearPlaza#index#();
		}
		</cfoutput>
	}
	//Obtiene la Descripción con base al código
	function TraePlaza<cfoutput>#index#</cfoutput>(dato) {
		var params = "";
		<cfoutput>
		if (document.#Attributes.form#.#Attributes.Dcodigo#.value.replace(" ", "") != "" && document.#Attributes.form#.#Attributes.Ocodigo#.value.replace(" ", "") != "" && document.#Attributes.form#.#Attributes.RHPpuesto#.value.replace(" ", "") != "") {
			params+= "&form=#Attributes.form#&conexion=#Attributes.conexion#";
			params+= "&atrRHPcodigo=#Attributes.RHPcodigo#&atrRHPdescripcion=#Attributes.RHPdescripcion#&atrRHPid=#Attributes.RHPid#";
			params+= "&RHPpuesto=" + document.#Attributes.form#.#Attributes.RHPpuesto#.value;
			params+= "&Dcodigo=" + document.#Attributes.form#.#Attributes.Dcodigo#.value;
			params+= "&Ocodigo=" + document.#Attributes.form#.#Attributes.Ocodigo#.value;
			params+= "&Ecodigo=#Attributes.Ecodigo#";
			params+= "&vfyplz=#Attributes.NoCheckPlazaOcupada#";
			params+= "&fechaAcc=#Attributes.fechaAccion#";
			if (dato!="") {
				var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
				fr.src = "/cfmx/rh/Utiles/rhplazaquery.cfm?dato="+dato+params;
			} else {
				ClearPlaza#index#();
			}
		} else {
			alert("Debe seleccionar un valor para Departamento, Oficina y Puesto antes de escoger la Plaza");
			ClearPlaza#index#();
		}
		</cfoutput>
	}
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset RHPcodigo = "#Evaluate('Attributes.query.#Evaluate('Attributes.RHPcodigo')#')#">
		<cfset RHPdescripcion = "#Evaluate('Attributes.query.#Evaluate('Attributes.RHPdescripcion')#')#">
		<cfset RHPid = "#Evaluate('Attributes.query.#Evaluate('Attributes.RHPid')#')#">
	</cfif>
	<cfoutput>
	<tr>
		<td>
			<input type="text" name="#Attributes.RHPcodigo#" id="#Attributes.RHPcodigo#"
			<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('RHPcodigo')#</cfif>" 
			onblur="javascript: TraePlaza#index#(document.#Attributes.form#.#Evaluate('Attributes.RHPcodigo')#.value); " onfocus="this.select()"
			size="10" 
			maxlength="10">
		</td>
		<td nowrap>
			<input type="text"
				name="#Attributes.RHPdescripcion#" id="#Attributes.RHPdescripcion#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('RHPdescripcion')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80">
			<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de plazas" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisPlaza#index#();'></a>
			<input type="hidden" name="#Attributes.RHPid#" value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('RHPid')#</cfif>">
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
