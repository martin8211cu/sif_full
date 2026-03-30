<cfif isDefined("url.RHCconcurso") and (len(trim(#url.RHCconcurso#)) NEQ 0) and not isDefined("form.RHCconcurso")>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
<cfif isDefined("url.paso") and (len(trim(#url.paso#)) NEQ 0) and not isDefined("form.paso")>
	<cfset form.paso = url.paso>
</cfif>




<cfif isDefined("session.Ecodigo") and isDefined("form.RHCconcurso") and len(trim(#form.RHCconcurso#)) NEQ 0>
    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
    <cf_dbfunction name="spart" args="#LvarRHCdescripcion#°1°55" delimiters="°" returnvariable="LvaRHCdescripcion">
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsRHConcursos" datasource="#Session.DSN#" >
		Select RHCconcurso, RHCcodigo, #LvaRHCdescripcion# as RHCdescripcion, 
			a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
			coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
			RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion
        from RHConcursos a
			left outer join RHPuestos b
				on a.RHPcodigo = b.RHPcodigo
				and a.Ecodigo = b.Ecodigo
			left outer join CFuncional c
				on a.CFid = c.CFid
				and a.Ecodigo = c.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#" >
		order by RHCdescripcion asc
	</cfquery>
</cfif>



<cfset def = QueryNew('dato')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" type="String" default=""> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.id" default="RHPid" type="string"> <!--- Nombre del id --->
<cfparam name="Attributes.name" default="RHPcodigo3" type="string"> <!--- Nombre del Código --->
<cfparam name="Attributes.desc" default="RHPdescripcion" type="string"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" default="frplazaconcursos" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.size" default="30" type="string"> <!--- tamaño del objeto de la descripcion --->
<cfparam name="Attributes.empresa" type="string" default=""> <!--- empresa --->

<cfif len(trim(Attributes.Conexion)) LT 1>
	<cfset Attributes.Conexion = Session.DSN>
</cfif>
<cfif len(trim(Attributes.Empresa)) LT 1>
	<cfset Attributes.Empresa = Session.Ecodigo>
</cfif>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis 
	function doConlisconsultaPlazaconcursos<cfoutput>#Attributes.name#</cfoutput>() {
		var params ="";
		params = "<cfoutput>?form=#Attributes.form#&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&empresa=#Attributes.empresa#&RHPpuesto=#rsRHConcursos.RHPcodigo#&CFid=#rsRHConcursos.CFid#&CFdescripcion=#rsRHConcursos.CFdescripcionresp#&RHPdescpuesto=#rsRHConcursos.RHPdescpuesto#&RHCconcurso=#rsRHConcursos.RHCconcurso#&RHCcodigo=#rsRHConcursos.RHCcodigo#&RHCcantplazas=#rsRHConcursos.RHCcantplazas#</cfoutput>";

		popUpWindow<cfoutput>#Attributes.name#</cfoutput>("/cfmx/rh/Utiles/ConlisconsultaPlazaconcursos.cfm"+params,250,50,650,630);
	}
	//Obtiene la descripción con base al código
/*	function TraePlazaconcursos<cfoutput>#Attributes.name#</cfoutput>(dato) {
		var params ="";
		params = "<cfoutput>&id=#Attributes.id#&name=#Attributes.name#&desc=#Attributes.desc#&conexion=#Attributes.conexion#&ecodigo=#Attributes.empresa#&RHPpuesto=#rsRHConcursos.RHPcodigo#&CFid=#rsRHConcursos.CFid#</cfoutput>";
		if (dato!="") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			fr.src = "/cfmx/rh/Utiles/rhplazaconcursosquery.cfm?dato="+dato+"&form="+"<cfoutput>#Attributes.form#</cfoutput>"+params;
		}
		else{
			//limpiarPlazaconcursos();
		}
		return;
	}*/
	/*function limpiarPlazaconcursos(){
	<cfoutput>
		document.#Attributes.form#.#Attributes.id#.value="";
		document.#Attributes.form#.#Attributes.name#.value="";
		document.#Attributes.form#.#Attributes.desc#.value="";
	</cfoutput>
	}*/
</script>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		<cfset id = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.id')#')#')">
		<cfset name = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		<cfset desc = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#')">		
	</cfif>
	<cfoutput>
	<tr>
		<td>
			  <input type="hidden"
				name="#Attributes.id#" id="#Attributes.id#"
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#id#')#</cfif>">
				
			<!--- <input type="text"
				name="#Attributes.name#" id="#Attributes.name#"
				<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#name#')#</cfif>" 
				onBlur="javascript: TraePlazaconcursos#Attributes.name#(document.#Attributes.form#.#Evaluate('Attributes.name')#.value); 
						if (window.func#Attributes.name#) {func#Attributes.name#();}" 
				onFocus="this.select()"
				size="10" 
				maxlength="10"> --->
		</td>
		<td nowrap>&nbsp;&nbsp;&nbsp;
<!--- 			<input type="text"
				name="#Attributes.desc#" id="#Attributes.desc#"
				tabindex="-1" disabled
				value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Evaluate('#desc#')#</cfif>" 
				size="#Attributes.size#" 
				maxlength="80"> --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ConsultarPlazas"
				Default="Consultar Plazas"
				returnvariable="LB_ConsultarPlazas"/>
			<a href="##" tabindex="-1" onClick='javascript: doConlisconsultaPlazaconcursos#Attributes.name#();'><strong>#LB_ConsultarPlazas#&nbsp;</strong><img src="/cfmx/rh/imagenes/findsmall.gif" alt="#LB_ConsultarPlazas#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisconsultaPlazaconcursos#Attributes.name#();'></a>
		</td>
	</tr>
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" id="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
