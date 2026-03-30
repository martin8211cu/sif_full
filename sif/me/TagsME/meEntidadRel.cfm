<!--- ( *** LEA ESTO ANTES DE USAR ESTE TAG *** )
Notas:
1. Este TAG puede ser utilizado de dos maneras, una es enviándole el tipo entidad1, esto cuando se quiere que el tipo de entidad seleccionado este relacionado
		por medio de la tabla de relaciones permitidas (MERelacionesPermitidas); otra es sin enviarle este parámetro en cuyo caso se muestran todas las entidades
		sin tomar en cuenta la tabla de relaciones permitidas.
2. REQUIERE LOS SIGUIENTES PARÁMETROS:
		-tipoEntidad1 (solo cuando se quiere que la entidad seleccionada este relacionada con la entidad 1).
3. Cuando se pasa el parametro query este debe contener los siguientes campos:
	*	MEEid2
	*	MEEidentificacion2
	*	MEEnombre2 "Corresponde al nombre completo"
	*	METRid (solo si se indica tipoentidad1)
--->

<!--- Consulta Pivot --->
<cfquery name="def" datasource="sdc">
	select '' as MEEid
</cfquery>

<!--- Parámetros Generales --->
<cfparam name="Attributes.tipoEntidad1" default="-1" type="string"> <!--- Código de la Entidad 1. si se necesita que la Entidad seleccionada tenga una Relación con esa Entidad 1 en la tabla de Relaciones Permitidas --->
<cfparam name="Attributes.conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la Conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del Form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- Consulta por Defecto --->
<cfparam name="Attributes.frame" default="frEntidadRel" type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.METRidsize" default="30" type="string"> <!--- Tamaño del objeto del Motivo --->
<cfparam name="Attributes.MEEidentificacion2size" default="30" type="string"> <!--- Tamaño del objeto de la identificación --->
<cfparam name="Attributes.MEEnombre2size" default="60" type="string"> <!--- Tamaño del objeto del Nombre --->
<cfparam name="Attributes.MEEid2" default="MEEid2" type="string"> <!--- Nombre del Objeto MEEid2 con el código de la Entidad  --->
<cfparam name="Attributes.MEEidentificacion2" default="MEEidentificacion2" type="string"> <!--- Nombre del Objeto MEEidentificacion2 con la identificación de la Entidad  --->
<cfparam name="Attributes.MEEnombre2" default="MEEnombre2" type="string"> <!--- Nombre del Objeto donde se despliega el nombre --->
<cfparam name="Attributes.METRid" default="METRid" type="string"> <!--- Nombre del Objeto METRid con el codigo Tipo de Relacion definido en Relaciones Permitidas ME --->
<cfparam name="Attributes.MERPdescripcion" default="MERPdescripcion" type="string"> <!--- Nombre del Objeto MERPdescripcion con la descripcion del Tipo de Relacion definido en Relaciones Permitidas ME --->
<cfparam name="Attributes.newTable" default="true" type="boolean"> <!--- Incluye nueva tabla --->
<cfparam name="Attributes.newTR" default="true" type="boolean"> <!--- Incluye nueva tr --->
<cfparam name="Attributes.tabIndex" default="-1" type="numeric"> <!--- TabIndex de los campos editables --->

<!--- Validación de tipoEntidad1 --->
<cfif Attributes.tipoEntidad1 neq "-1">
	<!--- Query de Motivos --->
	<cfquery name="rsMotivos" datasource="#Attributes.conexion#">
		select METRid, MERPdescripcion
		from MERelacionesPermitidas
		where METEid = <cfqueryparam value="#Attributes.tipoEntidad1#" cfsqltype="cf_sql_numeric"> /*TipoEntidad*/
	</cfquery>
</cfif><!--- Attributes.tipoEntidad1 neq "-1" --->

<cfoutput><!--- *** Abre CFOUTPUT *** --->

<!--- Scripts de lavantado del Conlis y de la consulta por texto --->
<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow#Attributes.MEEid2#(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) 
				popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}

	function doConlisEntidad#Attributes.MEEid2#(<cfif Attributes.tipoEntidad1 neq "-1">Motivo</cfif>) {
		var params = "";
		<cfif Attributes.tipoEntidad1 neq "-1">
		if (Motivo==""){
			alert("Motivo de la Relación Requerido. Seleccione Primero en Motivo de la Relación!");
			return false;
		}
		</cfif>
		//form y conexion
		params += "?form=#Attributes.form#";
		params += "&conexion=#Attributes.conexion#";
		//entidad a seleccionar
		params += "&MEEid2=#Attributes.MEEid2#";
		params += "&MEEidentificacion2=#Attributes.MEEidentificacion2#";
		params += "&MEEnombre2=#Attributes.MEEnombre2#";
		//valores del filtro
		<cfif Attributes.tipoEntidad1 neq "-1">
			params += "&METRid=" + Motivo;
		<cfelse>
			params += "&METRid=-1";
		</cfif>
		popUpWindow#Attributes.MEEid2#("/cfmx/sif/me/Utiles/ConlisMEEntidadRel.cfm"+params,250,200,650,400);
	}
	
	function ResetEntidad#Attributes.MEEid2#() {
		document.#Attributes.form#.#Attributes.MEEid2#.value = "";
		document.#Attributes.form#.#Attributes.MEEidentificacion2#.value = "";
		document.#Attributes.form#.#Attributes.MEEnombre2#.value = "";
	}

	function TraeEntidad#Attributes.MEEid2#(<cfif Attributes.tipoEntidad1 neq "-1">Motivo, </cfif>Identificacion) {
		/*alert(document.#Attributes.form#.#Attributes.MEEid2#.value);
		alert(document.#Attributes.form#.#Attributes.MEEidentificacion2#.value);
		alert(document.#Attributes.form#.#Attributes.MEEnombre2#.value);*/
		window.ctlMEEid2 =document.#Attributes.form#.#Attributes.MEEid2#;
		window.ctlMEEidentificacion2 = document.#Attributes.form#.#Attributes.MEEidentificacion2#;
		window.ctlMEEnombre2 = document.#Attributes.form#.#Attributes.MEEnombre2#;
		if (<cfif Attributes.tipoEntidad1 neq "-1">Motivo != "" && </cfif>Identificacion != "") {
			var fr = document.getElementById("#Attributes.frame#");
			var params = "conexion=#Attributes.conexion#";
			<cfif Attributes.tipoEntidad1 neq "-1">
				params += "&METRid=" +  Motivo;
			<cfelse>
				params += "&METRid=-1";
			</cfif>
			params += "&MEEidentificacion2=" + Identificacion;
			fr.src = "/cfmx/sif/me/Utiles/meentidadquery.cfm?"+params;
		} else {
			ResetEntidad#Attributes.MEEid2#();
		}
		return true;
	}
</script>

<!--- Saca los valores del Query cuando el query viene definido --->
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfif Attributes.tipoEntidad1 neq "-1">
		<cfset QMETRid = "Trim('#Evaluate('Attributes.query.METRid')#')">
	</cfif>
	<cfset QMEEid2 = "Trim('#Evaluate('Attributes.query.MEEid2')#')">
	<cfset QMEEidentificacion2 = "Trim('#Evaluate('Attributes.query.MEEidentificacion2')#')">
	<cfset QMEEnombre2 = "Trim('#Evaluate('Attributes.query.MEEnombre2')#')">
	<cfset QueryDef = "definido ok">
</cfif>

<!--- Pintado del TAG --->
<cfif Attributes.newTable>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
</cfif>
		<cfif Attributes.newTR>
		<tr>
		</cfif>
			<cfif Attributes.tipoEntidad1 neq "-1">
				<td nowrap>
					<select name="#Attributes.METRid#" onChange="javascript:ResetEntidad#Attributes.MEEid2#();" <cfif Attributes.tabIndex gt 0>tabindex="#Attributes.tabIndex#"</cfif>>
						<cfloop query="rsMotivos">
							<option value="#METRid#"<cfif isdefined('QueryDef') and Evaluate(QMETRid) eq METRid>selected</cfif>>#MERPdescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td nowrap>&nbsp;</td>
			</cfif>
			<td nowrap>
				<input type="text" name="#Attributes.MEEidentificacion2#" id="#Attributes.MEEidentificacion2#"
					size="#Attributes.MEEidentificacion2size#" maxlength="60" <cfif Attributes.tabIndex gt 0>tabindex="#Attributes.tabIndex#"</cfif>
					value="<cfif isdefined('QueryDef')>#Evaluate('#QMEEidentificacion2#')#</cfif>"
					onBlur="javascript: TraeEntidad#Attributes.MEEid2#(<cfif Attributes.tipoEntidad1 neq "-1">document.#Attributes.form#.#Attributes.METRid#.value, </cfif>this.value);">
			</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>
				<input type="text" name="#Attributes.MEEnombre2#" id="#Attributes.MEEnombre2#" 
					readonly="true" size="#Attributes.MEEnombre2size#" maxlength="120" tabindex="-1"
					value="<cfif isdefined('QueryDef')>#Evaluate('#QMEEnombre2#')#</cfif>">
				<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" 
					alt="Lista de entidades" name="imagen" width="18" height="14" border="0" align="absmiddle" <cfif Attributes.tabIndex gt 0>tabindex="#Attributes.tabIndex#"</cfif>
					onClick='javascript: doConlisEntidad#Attributes.MEEid2#(<cfif Attributes.tipoEntidad1 neq "-1">document.#Attributes.form#.#Attributes.METRid#.value</cfif>);'></a>
			</td>
			<td nowrap>
				<input type="hidden" name="#Attributes.MEEid2#" id="#Attributes.MEEid2#" tabindex="-1"
					value="<cfif isdefined('QueryDef')>#Evaluate('#QMEEid2#')#</cfif>">
			</td>
		<cfif Attributes.newTR>
		</tr>
		</cfif>
<cfif Attributes.newTable>
</table>
</cfif>

<cfif not isdefined("Request.EntidadRelTag")>
	<iframe id="#Attributes.frame#" name="#Attributes.frame#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
	<cfset Request.EmployeeTag = True>
</cfif>

</cfoutput><!--- *** Cierra CFOUTPUT *** --->
