
<!--- Parametros del Tag --->
<cfparam 	name="Attributes.id"					type="string"	default="">											<!--- Id de la Persona--->
<cfparam 	name="Attributes.form"					type="string"	default="form1">									<!--- form--->
<cfparam 	name="Attributes.pais"					type="string"	default="#session.saci.pais#">						<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam 	name="Attributes.incluyeTabla" 			type="boolean"	default="true">										<!--- incluye tabla --->
<cfparam 	name="Attributes.porFila" 				type="boolean"	default="false">									<!--- se utiliza para indicar si se pintan los niveles por columna o fila --->
<cfparam 	name="Attributes.columnas" 				type="string"	default="3">										<!--- indica la cantidad de columnas a permitir --->
<cfparam	name="Attributes.filtrarPersoneria"		type="string"	default="">											<!--- Se usa para filtrar los tipos de personeria que se requieren, se envían los códigos que se desean mostrar --->
<cfparam 	name="Attributes.sufijo" 				type="string"	default="">											<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.onchangePersoneria"	type="string"	default="funcionesOnchange#Attributes.sufijo#">		<!--- funcion que se ejecuta cada vez que se cambia de personeria--->
<cfparam 	name="Attributes.funcionValorEnBlanco"	type="string"	default="resetPersona#Attributes.sufijo#">			<!--- funcion que se ejecuta despues de que el campo de identificación se limpia --->
<cfparam 	name="Attributes.funcion"				type="string"	default="CargarValoresPersona#Attributes.sufijo#">	<!--- funcion que se ejecuta despues de que el colis trae los valores--->
<cfparam 	name="Attributes.Ecodigo" 				type="string"	default="#Session.Ecodigo#">						<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 				type="string"	default="#Session.DSN#">							<!--- cache de conexion --->
<cfparam 	name="Attributes.keyProspecto"			type="boolean"	default="false">									<!--- El Attributes.id es de la tabla ISBprospectos --->
<!---atributos nuevos para localizacion--->
<cfparam 	name="Attributes.TypeLocation"			type="string"	default="P">										<!--- Tipo de Entidad que usa el TAG, por ej: Agente, cuenta, cliente, representante.... --->
<cfparam 	name="Attributes.RefIdLocation"			type="string"	default="-1">											<!--- Id de Referencia asociado a la localizacion --->
<cfparam 	name="Attributes.showOnlyLocation"		type="boolean"	default="false">									<!--- Id de Referencia asociado a la localizacion --->
<!---fin / atributos nuevos para localizacion--->
<cfparam 	name="Attributes.readOnly_Pid"			type="boolean"	default="false">									<!--- Se usa si se quiere presentar como red only el campo de identificacion y personeria --->
<cfparam 	name="Attributes.id_duenno"				type="string"	default="-1">									<!--- Se usa para realizar el filtro de los representantes --->
<cfparam 	name="Attributes.TipodeAgente"			type="string"	default="Interno">							<!--- Indica si es un Vendedor de RACSA o un Agente Autorizado --->

<!--- Define el modo--->
<cfif isdefined("Attributes.id") and len(trim(Attributes.id))>
	<cfset Attributes.id = val(Attributes.id)>
	<cfset modo="CAMBIO">	
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfset mask = "">
<cfquery datasource="#Attributes.Conexion#" name="rsMask">
	select Pvalor 
		from ISBparametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	  and Pcodigo = 60
</cfquery>

<cfif rsMask.recordCount gt 0 and len(trim(rsMask.Pvalor))>
	<cfset mask = trim(rsMask.Pvalor)>
</cfif>


<!--- Datos de la persona --->	
<cfif modo neq "ALTA">

	<!--- Verifica si existe Localizacion--->
	<cfquery datasource="#Attributes.Conexion#" name="rsExistsLocation">
		select count(1) as r
			from ISBlocalizacion 
		where RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefIdLocation#" null="#Len(Attributes.RefIdLocation) Is 0#">
		and Ltipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.TypeLocation#" null="#Len(Attributes.TypeLocation) Is 0#"> 
	</cfquery>
	
	<cfset ExistsLocation = false>
	<cfif rsExistsLocation.r gt 0>
		<cfset ExistsLocation = true>
	</cfif>
	<cfif Attributes.TypeLocation eq "P">
		<cfquery datasource="#Attributes.Conexion#" name="rsPersonaTag">
			select 
				   <cfif Attributes.keyProspecto>
						'' as Pquien,			   
				   <cfelse>
						a.Pquien, 
				   </cfif>		
				   a.Ppersoneria, 
				   a.Pid, 
				   a.Pnombre, 
				   a.Papellido, 
				   a.Papellido2, 
				   a.PrazonSocial, 
				   a.Ppais, 
				   a.Pobservacion, 
				   a.Pprospectacion, 
				   <cfif Attributes.keyProspecto>
						'' as AEactividad,			   
				   <cfelse>
						a.AEactividad, 
				   </cfif>
				   a.CPid as CPid#Attributes.sufijo#, 
				   rtrim(a.Papdo) as Papdo#Attributes.sufijo#, 
				   a.LCid, 
				   a.Pdireccion, 
				   a.Pbarrio, 
				   rtrim(a.Ptelefono1) as Ptelefono1, 
				   rtrim(a.Ptelefono2) as Ptelefono2, 
				   rtrim(a.Pfax) as Pfax, 
				   a.Pemail, 
				   a.Pfecha,
				   b.CPnombre,
				   a.ts_rversion
			from   
				<cfif Attributes.keyProspecto>
					ISBprospectos a
				<cfelse>
					ISBpersona a
				</cfif>			   
				left outer join OficinaPostal b
					on b.CPid = a.CPid
					and b.Ppais = '#Attributes.pais#'
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
			<cfif not Attributes.keyProspecto>
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
			</cfif>
		</cfquery>
	<cfelse>
			<cfif ExistsLocation>
				<!---<cfif Attributes.TypeLocation eq "A" or Attributes.TypeLocation eq "C" or Attributes.TypeLocation eq "V">--->
					<cfquery datasource="#Attributes.Conexion#" name="rsPersonaTag">
						select 
							   a.Pquien, 
							   a.Ppersoneria, 
							   a.Pid, 
							   a.Pnombre, 
							   a.Papellido, 
							   a.Papellido2, 
							   a.PrazonSocial, 
							   a.Ppais, 
							   a.Pprospectacion, 
							   a.AEactividad, 
							   c.CPid as CPid#Attributes.sufijo#, 
							   rtrim(c.Papdo) as Papdo#Attributes.sufijo#, 
							   c.LCid, 
							   c.Pdireccion, 
							   c.Pbarrio, 
							   rtrim(c.Ptelefono1) as Ptelefono1, 
							   rtrim(c.Ptelefono2) as Ptelefono2, 
							   rtrim(c.Pfax) as Pfax, 
							   c.Pemail, 
							   c.Pobservacion,
							   c.Pfecha,
							   op.CPnombre,
							   a.ts_rversion as ts_rversionp,
							   c.ts_rversion as ts_rversionl,
							   b.ts_rversion as ts_rversion_agente_p,
							   c.Lid
						from ISBpersona a inner join 
									<cfif Attributes.TypeLocation eq "A">
										ISBagente b  on a.Pquien = b.Pquien
									<cfelseif Attributes.TypeLocation eq "C">
										ISBcuenta b  on a.Pquien = b.Pquien
									<cfelseif Attributes.TypeLocation eq "V">
										ISBvendedor b  on a.Pquien = b.Pquien
									<cfelseif Attributes.TypeLocation eq "R">
										ISBpersonaRepresentante b  on a.Pquien = b.Pcontacto
									</cfif>
							 inner join ISBlocalizacion c
								on c.RefId = 
									<cfif Attributes.TypeLocation eq "A">
										b.AGid
									<cfelseif Attributes.TypeLocation eq "C">
										b.CTid
									<cfelseif Attributes.TypeLocation eq "V">
										b.Vid
									<cfelseif Attributes.TypeLocation eq "R">
										b.Rid
									</cfif>
							left outer join OficinaPostal op
								on op.CPid = c.CPid
								and op.Ppais = '#Attributes.pais#'
						where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
						  and c.RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefIdLocation#" null="#Len(Attributes.RefIdLocation) Is 0#">
						  and c.Ltipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.TypeLocation#" null="#Len(Attributes.TypeLocation) Is 0#"> 
						  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
						  
					</cfquery>
			<cfelse>
				<cfquery datasource="#Attributes.Conexion#" name="rsPersonaTag">
					select 
						   a.Pquien, 
						   a.Ppersoneria, 
						   a.Pid, 
						   a.Pnombre, 
						   a.Papellido, 
						   a.Papellido2, 
						   a.PrazonSocial, 
						   a.Ppais,  
						   a.Pprospectacion, 
						   a.AEactividad, 
						   null as CPid#Attributes.sufijo#, 
						   null as Papdo#Attributes.sufijo#, 
						   null as LCid, 
						   null as Pdireccion, 
						   null as Pbarrio, 
						   null as Ptelefono1, 
						   null as Ptelefono2, 
						   null as Pfax, 
						   null as Pemail, 
						   null as Pobservacion,
						   null as Pfecha,
						   null as CPnombre,
						   a.ts_rversion as ts_rversionp,
						   null as ts_rversionl,
						   null as ts_rversion_agente_p,
						   null as Lid
						   
					from  
						ISBpersona a
					where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#" null="#Len(Attributes.id) Is 0#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
				</cfquery>
			</cfif>
	</cfif>
	
	<!--- Consulta los VALORES de los Atributos Extendidos Juridicos de la persona actual--->
	<cfquery datasource="#Attributes.Conexion#" name="rsValAtrJuridico">
		select c.Aid, c.Aetiq, c.AtipoDato, b.PAvalor  
		from ISBpersona a
			left outer join ISBatributo c
			on c.Habilitado=1
			and c.AapJuridica=1
	
			left outer join ISBpersonaAtributo b
			on a.Pquien = b.Pquien
			and c.Aid=b.Aid

		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		order by c.Aid
	</cfquery>
	
	<!--- Consulta los VALORES de los Atributos Extendidos Fisicos de la persona actual--->
	<cfquery datasource="#Attributes.Conexion#" name="rsValAtrFisico">
		select
				c.Aid, c.Aetiq, c.AtipoDato, b.PAvalor  
		from 	
				ISBpersona a
			
				left outer join ISBatributo c
				on c.Habilitado=1
				and c.AapFisica=1
				and c.AapJuridica=0
		
				left outer join ISBpersonaAtributo b
				on a.Pquien = b.Pquien
				and c.Aid=b.Aid
		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		order by c.Aid
	</cfquery>

<cfelseif modo eq "ALTA" and Attributes.showOnlyLocation>
	<cfquery datasource="#Attributes.Conexion#" name="rsPersonaTag">
		select 
			   a.CPid as CPid#Attributes.sufijo#, 
			   rtrim(a.Papdo) as Papdo#Attributes.sufijo#, 
			   a.LCid, 
			   a.Pdireccion, 
			   a.Pbarrio, 
			   rtrim(a.Ptelefono1) as Ptelefono1, 
			   rtrim(a.Ptelefono2) as Ptelefono2, 
			   rtrim(a.Pfax) as Pfax, 
			   a.Pemail, 
			   a.Pfecha,
			   b.CPnombre
		from   
			<cfif Attributes.TypeLocation eq "P">
				ISBpersona a
			<cfelse>
				ISBlocalizacion a
			</cfif>
			left outer join OficinaPostal b
				on b.CPid = a.CPid
				and b.Ppais = '#Attributes.pais#'
		where 
			<cfif Attributes.TypeLocation eq "P">
				a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefIdLocation#" null="#Len(Attributes.RefIdLocation) Is 0#">
			<cfelse>
				a.RefId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.RefIdLocation#" null="#Len(Attributes.RefIdLocation) Is 0#">
			</cfif>
			
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	</cfquery>
		
</cfif>

<!--- Consulta de Atributos Extendidos Juridicos--->
<cfquery datasource="#Attributes.Conexion#" name="rsAtrJuridico">
	select Aid,Aetiq,AtipoDato 
	from ISBatributo
	where Habilitado=1
		and AapJuridica=1
	order by Aid
</cfquery>
<!--- Consulta de Atributos Extendidos Fisicos, excluyendo los atributos que tambien son Juridico, pues ya fueros tomados en cuenta en la cunsulta de atributos Juridicos--->
<cfquery datasource="#Attributes.Conexion#" name="rsAtrFisico">
	select Aid,Aetiq,AtipoDato 
	from ISBatributo
	where Habilitado=1
		and AapFisica=1
		and AapJuridica=0
	order by Aid
</cfquery>

<cfoutput>
	<!--- PINTADO DE  LOS CAMPOS --->
	<cfset tsp = "">
	<cfset tsl = "">
	<cfset ts2 = "">
	<cfset lid = "">
	<cfif modo EQ "CAMBIO">
		<cfif Attributes.TypeLocation eq "P">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsPersonaTag.ts_rversion#" returnvariable="tsp">
			</cfinvoke>
		<cfelse>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsPersonaTag.ts_rversionp#" returnvariable="tsp">
			</cfinvoke>		
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsPersonaTag.ts_rversionl#" returnvariable="tsl">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#rsPersonaTag.ts_rversion_agente_p#" returnvariable="ts2">
			</cfinvoke>

			<cfset lid="#rsPersonaTag.Lid#">
		</cfif>
	</cfif>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>

	<cfif Attributes.TypeLocation eq "P">
		<input type="hidden" name="ts_rversion#Attributes.sufijo#" value="#tsp#">
	<cfelse>
		<input type="hidden" name="ts_rversionp#Attributes.sufijo#" value="#tsp#">
		<input type="hidden" name="ts_rversionl#Attributes.sufijo#" value="#tsl#">
		<input type="hidden" name="ts_rversion_agente_p#Attributes.sufijo#" value="#ts2#">
		<input type="hidden" name="Lid#Attributes.sufijo#" value="#lid#">
	</cfif>
	
	<cfif not Attributes.showOnlyLocation>
		<input type="hidden" name="Pquien_Ant#Attributes.sufijo#" value="<cfif isdefined("rsPersonaTag")>#Trim(rsPersonaTag.Pquien)#</cfif>" />
		<input type="hidden" name="Pid_Ant#Attributes.sufijo#" value="<cfif isdefined("rsPersonaTag")>#rsPersonaTag.Pid#</cfif>" />
	</cfif>
	<cfif Attributes.keyProspecto>
		<input type="hidden" name="idprospecto#Attributes.sufijo#" value="#Attributes.id#" />
	</cfif>
	<cfif Attributes.incluyeTabla>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	</cfif>
		<cfif not Attributes.showOnlyLocation>
			<cfset ident="">
			<cfset RefIdL="">
			
			<cfif modo neq "ALTA">
				<cfset ident=Attributes.id>
				<cfset RefIdL=#Attributes.RefIdLocation#>
			</cfif>
			<cf_identificacion
				form = "#Attributes.form#"
				Ecodigo = "#Attributes.Ecodigo#"
				Conexion = "#Attributes.Conexion#"
				onchangePersoneria = "#Attributes.onchangePersoneria#"
				funcionValorEnBlanco = "#Attributes.funcionValorEnBlanco#"
				funcion = "#Attributes.funcion#"
				alignEtiquetas = "right"
				colspan = "3"
				incluyeTabla = "false"
				porFila = "#Attributes.porFila#"
				filtrarPersoneria = "#Attributes.filtrarPersoneria#"
				sufijo = "#Attributes.sufijo#"
				keyProspecto="#Attributes.keyProspecto#"
				id = "#ident#"
				readOnly="#Attributes.readOnly_Pid#"
				TypeLocation = "#Attributes.TypeLocation#"
				RefIdLocation = "#RefIdL#"
				id_duenno = "#Attributes.id_duenno#"
				TipodeAgente = "#Attributes.TipodeAgente#"
			>
			<tr id="Juridic#Attributes.sufijo#">
				<td align="right"  valign="middle"><label>Raz&oacute;n Social</label></td>
				<td align="left"  valign="middle" <cfif Attributes.porFila EQ False>colspan="5"</cfif>>
					<input name="PrazonSocial#Attributes.sufijo#" onBlur="javascript:this.value = this.value.toUpperCase();" id="PrazonSocial#Attributes.sufijo#" type="text" value="<cfif modo neq "ALTA">#HTMLEditFormat(Trim(rsPersonaTag.PrazonSocial))#</cfif>" maxlength="100" onfocus="this.select()" style="width: 100%" tabindex="1" /> 
				</td>
			</tr>
			<tr id="trNombreCompleto#Attributes.sufijo#">
				<td align="right" valign="middle"><label><cf_traducir key="nombre">Nombre</cf_traducir></label></td>
				<td  align="left" valign="middle"><input name="Pnombre#Attributes.sufijo#" id="Pnombre#Attributes.sufijo#" type="text" value="<cfif modo neq "ALTA">#HTMLEditFormat(Trim(rsPersonaTag.Pnombre))#</cfif>" 
					maxlength="80"
					onBlur="javascript: validaBlancos(this); this.value = this.value.toUpperCase();"
					onfocus="this.select()" tabindex="1"/>
				</td>
			<cfif Attributes.porFila></tr><tr></cfif>
				<td  align="right" valign="middle" nowrap><label>1er Apellido</label></td>
				<td  align="left" valign="middle"><input name="Papellido#Attributes.sufijo#" id="Papellido#Attributes.sufijo#" type="text" value="<cfif modo neq "ALTA">#HTMLEditFormat(Trim(rsPersonaTag.Papellido))#</cfif>" 
						maxlength="30"
						onBlur="javascript: validaBlancos(this); this.value = this.value.toUpperCase();"
						onfocus="this.select()" tabindex="1" />
				</td>
			<cfif Attributes.porFila></tr><tr></cfif>
				<td align="right"  valign="middle" id="apell2L#Attributes.sufijo#" nowrap><label>2do Apellido</label></td>
				<td  align="left" valign="middle" id="apell2T#Attributes.sufijo#"><input name="Papellido2#Attributes.sufijo#" id="Papellido2#Attributes.sufijo#" type="text" value="<cfif modo neq "ALTA">#HTMLEditFormat(Trim(rsPersonaTag.Papellido2))#</cfif>" 
						maxlength="30"
						onfocus="this.select()" tabindex="1"
						onBlur="javascript: this.value = this.value.toUpperCase();"/>
				</td>
			</tr>
			<tr>
				<td align="right" id="paisOrL#Attributes.sufijo#" valign="middle"><label>Pa&iacute;s de Origen</label></td>
				<td align="left" id="paisOrT#Attributes.sufijo#" valign="middle">
					<cfif modo EQ "CAMBIO">
						<cfset idpais = rsPersonaTag.Ppais>
					<cfelse>
						<cfset idpais = Attributes.pais>
					</cfif>
					<cf_pais
						id = "#idpais#"
						form = "#Attributes.form#"
						sufijo = "#Attributes.sufijo#"
						Ecodigo = "#Attributes.Ecodigo#"
						Conexion = "#Attributes.Conexion#"
					>
				</td>
					 	
			<cfif Attributes.porFila></tr><tr></cfif>	
										
					<cfif isdefined('Attributes.TypeLocation') and Not ListFind('A,V', Attributes.TypeLocation)>
					<td align="right" style="visibility:visible" valign="middle"><label>Actividad Econ&oacute;mica</label></td>
						<td align="left"  style="visibility:visible"  valign="middle" colspan="3">
							<cfif modo EQ "CAMBIO">
								<cfset idactividad = rsPersonaTag.AEactividad>
							<cfelse>
								<cfset idactividad = ''>
							</cfif>
							<cf_actividadEconomica
								id = "#idactividad#"
								form = "#Attributes.form#"
								sufijo = "#Attributes.sufijo#"
								Ecodigo = "#Attributes.Ecodigo#"
								Conexion = "#Attributes.Conexion#"
							>
						</td>
					</tr>
					</cfif>
		</cfif>
		<tr>
			<td align="right" valign="middle" width="15%"><label>Tel&eacute;fono</label></td>
			<td align="left" valign="middle" nowrap>
				<cfset tel = "">
				<cfif modo neq "ALTA" or isdefined("rsPersonaTag")>
					<cfset tel = HTMLEditFormat(Trim(rsPersonaTag.Ptelefono1))>
				</cfif>
				<!-----<cf_campoNumerico nullable="true" name="Ptelefono1#Attributes.sufijo#" decimales="-1" size="17" maxlength="15" value="#tel#" tabindex="1">----->
				<input type="hidden" name="Ptelefono1#Attributes.sufijo#" id="Ptelefono1#Attributes.sufijo#" value="#HtmlEditFormat(tel)#">
				
				<input type="text" 
					name="_Ptelefono1#Attributes.sufijo#" 
					size="20" 
					maxlength="15" 
					onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.Ptelefono1#Attributes.sufijo#);"
					onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.Ptelefono1#Attributes.sufijo#);"
					onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.Ptelefono1#Attributes.sufijo#.value)"
					value=""
					tabindex="1"
					style="text-align:right;"
				>
				<font style="font-weight: normal; font-family: Arial, Verdana; font-size: xx-small; color: gray;">#mask#</font>
				
				
			</td>
		<cfif Attributes.porFila></tr><tr></cfif>
			<td  align="right" valign="middle" nowrap><label>Tel&eacute;fono 2/Cel.</label></td>
			<td  align="left" valign="middle" nowrap>
				<cfset tel = "">
				<cfif modo neq "ALTA" or isdefined("rsPersonaTag")>
					<cfset tel = HTMLEditFormat(Trim(rsPersonaTag.Ptelefono2))>
				</cfif>
				<!-----<cf_campoNumerico nullable="true" name="Ptelefono2#Attributes.sufijo#" decimales="-1" size="17" maxlength="15" value="#tel#" tabindex="1">----->
				<input type="hidden" name="Ptelefono2#Attributes.sufijo#" id="Ptelefono2#Attributes.sufijo#" value="#HtmlEditFormat(tel)#">
				
				<input type="text" 
					name="_Ptelefono2#Attributes.sufijo#" 
					size="20" 
					maxlength="15" 
					onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.Ptelefono2#Attributes.sufijo#);"
					onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.Ptelefono2#Attributes.sufijo#);"
					onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.Ptelefono2#Attributes.sufijo#.value)"
					value=""
					tabindex="1"
					style="text-align:right;"
				>
				<font style="font-weight: normal; font-family: Arial, Verdana; font-size: xx-small; color: gray;">#mask#</font>
				
			</td>
		<cfif Attributes.porFila></tr><tr></cfif>
			<td align="right" valign="middle"><label>Fax</label></td>
			<td align="left"  valign="middle" nowrap>
				<cfset tel = "">
				<cfif modo neq "ALTA" or isdefined("rsPersonaTag")>
					<cfset tel = HTMLEditFormat(Trim(rsPersonaTag.Pfax))>
				</cfif>
				<!----<cf_campoNumerico nullable="true" name="Pfax#Attributes.sufijo#" decimales="-1" size="17" maxlength="15" value="#tel#" tabindex="1">--->
				<input type="hidden" name="Pfax#Attributes.sufijo#" id="Pfax#Attributes.sufijo#" value="#HtmlEditFormat(tel)#">
				
				<input type="text" 
					name="_Pfax#Attributes.sufijo#" 
					size="20" 
					maxlength="15" 
					onBlur="javascript: validateMask#Attributes.sufijo#(this, document.all.Pfax#Attributes.sufijo#);"
					onKeyUp="javascript: this.value = trim(this.value); filtraChars#Attributes.sufijo#(event,this,document.all.Pfax#Attributes.sufijo#);"
					onkeydown="javascript: this.value = textToMask#Attributes.sufijo#(document.all.Pfax#Attributes.sufijo#.value)"
					value=""
					tabindex="1"
					style="text-align:right;"
				>
				<font style="font-weight: normal; font-family: Arial, Verdana; font-size: xx-small; color: gray;">#mask#</font>
				
			</td>
		</tr>
		
		<tr>
			  <td  align="right" valign="middle"><label>Apdo Postal</label></td>
			  <td align="left"  valign="middle">
				<cfif modo eq "CAMBIO" or isdefined("rsPersonaTag")>
					<cfset queryDef = rsPersonaTag>
				<cfelse>
					<cfset queryDef = QueryNew('indefinido')>
				</cfif>
				<cf_apdopostal
					query = "#queryDef#"
					pais = "#Attributes.pais#"
					form = "#Attributes.form#"
					sufijo = "#Attributes.sufijo#"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
				>
			  </td>
		<cfif Attributes.porFila></tr><tr></cfif>
			  <td  align="right" valign="middle"><label>E-mail</label></td>
			  <td  align="left" valign="middle">
			  	<input name="Pemail#Attributes.sufijo#" 
					id="Pemail#Attributes.sufijo#" 
					type="text" 
					onBlur="javascript:emailCheck#Attributes.sufijo#(this.value);"
					value="<cfif modo neq "ALTA" or isdefined("rsPersonaTag")>#HTMLEditFormat(Trim(rsPersonaTag.Pemail))#</cfif>" 
					size="30" maxlength="50"
					onfocus="this.select()" tabindex="1" />
			  </td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		</tr>
			<cfif modo eq "CAMBIO" or isdefined("rsPersonaTag")>
				<cfset idLocalidad = rsPersonaTag.LCid>
			<cfelse>
				<cfset idLocalidad = ''>
			</cfif>
			<cf_localidad 
				id = "#idLocalidad#"
				pais = "#Attributes.pais#"
				form = "form1"
				porFila = "#Attributes.porFila#"
				incluyeTabla = "false"
				alignEtiquetas = "right"
				sufijo = "#Attributes.sufijo#"
				Ecodigo = "#Attributes.Ecodigo#"
				Conexion = "#Attributes.Conexion#"
			>
		
		<tr>
			<td align="right" valign="middle"><label>Barrio</label></td>
			<td colspan="5" align="left" valign="middle">
				<input name="Pbarrio#Attributes.sufijo#" maxlength="80" id="Pbarrio#Attributes.sufijo#" onblur="javascript: this.value = this.value.toUpperCase();" type="text" value="<cfif modo neq "ALTA" or isdefined("rsPersonaTag")>#HTMLEditFormat(Trim(rsPersonaTag.Pbarrio))#</cfif>" maxlength="80" onfocus="this.select()" style="width: 100%" tabindex="1" />
			</td>		
		</tr>
	
		<tr>
			<td align="right" valign="middle"><label>Direcci&oacute;n Exacta</label></td>
			<td align="left" valign="middle" colspan="5">
				<textarea name="Pdireccion#Attributes.sufijo#" id="Pdireccion#Attributes.sufijo#" onblur="javascript: this.value = this.value.toUpperCase();" style="width: 100%" tabindex="1"><cfif modo neq "ALTA" or isdefined("rsPersonaTag")>#HTMLEditFormat(Trim(rsPersonaTag.Pdireccion))#</cfif></textarea>		
			</td>
		</tr>
		<cfif  not Attributes.showOnlyLocation>
		<tr>
			<td align="right" valign="top"><label>Observaciones</label></td>
			<td align="left" valign="middle" colspan="5">
				<textarea name="Pobservacion#Attributes.sufijo#" id="Pobservacion#Attributes.sufijo#" rows="3" onblur="javascript: this.value = this.value.toUpperCase();" style="width: 100%" tabindex="1"><cfif modo neq "ALTA">#HTMLEditFormat(Trim(rsPersonaTag.Pobservacion))#</cfif></textarea>
			</td>
		</tr>
		<tr>
			<td align="center" valign="middle" colspan="6">
				<cfset tipo_persona="1">
				<cfset id_persona="">
				<cfset ident_persona="">
				<cfset form_act = Attributes.form>
				<cfif modo neq "ALTA">
						<cfset tipo_persona = Iif(rsPersonaTag.Ppersoneria EQ "F", DE("1"), DE("2"))>
						<cfset id_persona 	= rsPersonaTag.Pquien>
						<cfset ident_persona= rsPersonaTag.Pid>
				</cfif>
				
				<cf_atrExtendidos
					tipo="#tipo_persona#"
					id="#id_persona#"
					identificacion="#ident_persona#"
					form="#form_act#"
					columnas="#Attributes.columnas#"
					sufijo="#Attributes.sufijo#"
				>
			</td>				
		</tr>
		</cfif>
	<cfif Attributes.incluyeTabla>
	</table>
	</cfif>
  
</cfoutput>

<script type="text/javascript" language="javascript">
	
	<cfoutput>
	
	<!--- caso en que viene como parametro el id, al hacer clic en otro tab y volver, para que no se pierda el identificador--->
	<cfif modo eq "CAMBIO" and not Attributes.showOnlyLocation>
		document.#Attributes.form#.Pid#Attributes.sufijo#.value = "#rsPersonaTag.Pid#";
		document.#Attributes.form#.CPid#Attributes.sufijo#.value = "#Evaluate('rsPersonaTag.CPid' & Attributes.sufijo)#";
	</cfif>
	
	function resetPersona#Attributes.sufijo#() {
		<!---if ((document.#Attributes.form#.Pid#Attributes.sufijo#.value != document.#Attributes.form#.Pid_Ant#Attributes.sufijo#.value) && (document.#Attributes.form#.Pquien#Attributes.sufijo#.value == document.#Attributes.form#.Pquien_Ant#Attributes.sufijo#.value)) {--->
		
		if ((document.#Attributes.form#.PidSinMask#Attributes.sufijo#.value != document.#Attributes.form#.Pid_Ant#Attributes.sufijo#.value) && (document.#Attributes.form#.Pquien#Attributes.sufijo#.value == document.#Attributes.form#.Pquien_Ant#Attributes.sufijo#.value)) {	
			document.#Attributes.form#.Pnombre#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Papellido#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Papellido2#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Ptelefono1#Attributes.sufijo#.value = "";
			document.#Attributes.form#._Ptelefono1#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Pfax#Attributes.sufijo#.value = "";
			document.#Attributes.form#._Pfax#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Pdireccion#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Pobservacion#Attributes.sufijo#.value = "";
			document.#Attributes.form#.Pemail#Attributes.sufijo#.value = "";
		}
		document.#Attributes.form#.Pquien_Ant#Attributes.sufijo#.value = document.#Attributes.form#.Pquien#Attributes.sufijo#.value;
		document.#Attributes.form#.Pid_Ant#Attributes.sufijo#.value = document.#Attributes.form#.PidSinMask#Attributes.sufijo#.value;
		<!---document.#Attributes.form#.Pid_Ant#Attributes.sufijo#.value = document.#Attributes.form#.Pid#Attributes.sufijo#.value;--->
	}
	
	<!--- Asigna los datos que retorna el conlis a los campos correspondientes --->
	function CargarValoresPersona#Attributes.sufijo#() {
		
			resetPersona#Attributes.sufijo#();
		
		if (document.#Attributes.form#.Pquien#Attributes.sufijo#.value !="") {
			formatMascara#Attributes.sufijo#();		//funcion que se encuentra en el tag de identificacion, se usa para dar formato a la identificacion dependiendo de la personeria. Se ejecuta al traer un nuevo identificador.
			
			document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value = document.#Attributes.form#.Ppersoneriap#Attributes.sufijo#.value;
			document.#Attributes.form#.Pnombre#Attributes.sufijo#.value = document.#Attributes.form#.Pnombrep#Attributes.sufijo#.value;
			document.#Attributes.form#.Papellido#Attributes.sufijo#.value = document.#Attributes.form#.Papellidop#Attributes.sufijo#.value;
			document.#Attributes.form#.Papellido2#Attributes.sufijo#.value = document.#Attributes.form#.Papellido2p#Attributes.sufijo#.value;
			document.#Attributes.form#.PrazonSocial#Attributes.sufijo#.value = document.#Attributes.form#.PrazonSocialp#Attributes.sufijo#.value;
			document.#Attributes.form#.Pobservacion#Attributes.sufijo#.value = document.#Attributes.form#.Pobservacionp#Attributes.sufijo#.value;
			document.#Attributes.form#.Pdireccion#Attributes.sufijo#.value = document.#Attributes.form#.Pdireccionp#Attributes.sufijo#.value;
			document.#Attributes.form#.Pbarrio#Attributes.sufijo#.value = document.#Attributes.form#.Pbarriop#Attributes.sufijo#.value;
			document.#Attributes.form#.Ptelefono1#Attributes.sufijo#.value = document.#Attributes.form#.Ptelefono1p#Attributes.sufijo#.value;
			document.#Attributes.form#._Ptelefono1#Attributes.sufijo#.value = document.#Attributes.form#.Ptelefono1p#Attributes.sufijo#.value;
			document.#Attributes.form#.Ptelefono2#Attributes.sufijo#.value = document.#Attributes.form#.Ptelefono2p#Attributes.sufijo#.value;
			document.#Attributes.form#.Pfax#Attributes.sufijo#.value = document.#Attributes.form#.Pfaxp#Attributes.sufijo#.value;
			document.#Attributes.form#.Pemail#Attributes.sufijo#.value = document.#Attributes.form#.Pemailp#Attributes.sufijo#.value;
			<cfif Attributes.TypeLocation eq "P">
				document.#Attributes.form#.ts_rversion#Attributes.sufijo#.value = document.#Attributes.form#.ts_rversionp#Attributes.sufijo#.value;
			<cfelse>
				
				document.#Attributes.form#.ts_rversionp#Attributes.sufijo#.value = document.#Attributes.form#.ts_rversionpp#Attributes.sufijo#.value;
				document.#Attributes.form#.ts_rversionl#Attributes.sufijo#.value = document.#Attributes.form#.ts_rversionlp#Attributes.sufijo#.value;
				
				if (document.#Attributes.form#.ts_rversion_agente#Attributes.sufijo# != undefined)
					document.#Attributes.form#.ts_rversion_agente#Attributes.sufijo#.value = document.#Attributes.form#.ts_rversion_agente_i#Attributes.sufijo#.value;
				if (document.#Attributes.form#.AGid#Attributes.sufijo# != undefined)
					document.#Attributes.form#.AGid#Attributes.sufijo#.value = document.#Attributes.form#.AGidp#Attributes.sufijo#.value;			
				document.#Attributes.form#.Lid#Attributes.sufijo#.value = document.#Attributes.form#.Lidp#Attributes.sufijo#.value;
			</cfif>
			
			CargarValoresPais#Attributes.sufijo#(document.#Attributes.form#.Ppaisp#Attributes.sufijo#.value);
			CargarValoresApdo#Attributes.sufijo#(document.#Attributes.form#.Papdop#Attributes.sufijo#.value, document.#Attributes.form#.CPidp#Attributes.sufijo#.value);
			CargarValoresLocalidad#Attributes.sufijo#(document.#Attributes.form#.LCidp#Attributes.sufijo#.value);
			<cfif isdefined('Attributes.TypeLocation') and Attributes.TypeLocation neq 'A'>
			CargarValoresActividad#Attributes.sufijo#(document.#Attributes.form#.AEactividadp#Attributes.sufijo#.value);
			</cfif>
			<!--- Funcion que pinta los campos segun la personeria --->
			esJuridica#Attributes.sufijo#(document.#Attributes.form#.Ppersoneria#Attributes.sufijo#);
			
			<!--- Funcion del Tag de Atributos Extendidos --->
			var personeria = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value;
			var id = document.#Attributes.form#.Pquien#Attributes.sufijo#.value;
			MostrarCampos#Attributes.sufijo#((personeria=='F'?'1':(personeria=='J'?'2':'')));
			ActualizaValoresExtendidos#Attributes.sufijo#((personeria=='F'?'1':(personeria=='J'?'2':'')),id);
			validar_identificacion#Attributes.sufijo#();
			CargarFormatoTels#Attributes.sufijo#();
		}
				
	}
	
	function CargarFormatoTels#Attributes.sufijo#(){
		
			/***--se carga los valores iniciales de telefonos--****/
			var fv = document.all.Ptelefono1#Attributes.sufijo#.value;
			if(fv.length > 0)
				document.all._Ptelefono1#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
			fv = document.all.Ptelefono2#Attributes.sufijo#.value;
			if(fv.length > 0)
				document.all._Ptelefono2#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);	
			fv = document.all.Pfax#Attributes.sufijo#.value;
			if(fv.length > 0)
				document.all._Pfax#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
			/*****Fin de carga****/
	
		}
		
	<!--- Aparece y desaparece los campos que son especficos para las personas de tipo Jurdico --->
	function esJuridica#Attributes.sufijo#()
	{
		var tipo = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value; 
		if (tipo=="J") {
			document.getElementById('trNombreCompleto#Attributes.sufijo#').style.display='none'; 	<!--- Nombre Completo --->
			document.getElementById('Juridic#Attributes.sufijo#').style.display='';					<!--- Razon Social --->
			document.getElementById('paisOrL#Attributes.sufijo#').style.display='none';				<!--- Etiqueta Pais --->
			document.getElementById('paisOrT#Attributes.sufijo#').style.display='none';				<!--- Campo Pais --->
		} else if(tipo=="F") {
			document.getElementById('trNombreCompleto#Attributes.sufijo#').style.display=''; 		<!--- Nombre Completo --->
			document.getElementById('Juridic#Attributes.sufijo#').style.display='none';				<!--- Razon Social --->
			document.getElementById('paisOrL#Attributes.sufijo#').style.display='none';				<!--- Etiqueta Pais --->
			document.getElementById('paisOrT#Attributes.sufijo#').style.display='none';				<!--- Campo Pais --->
		} else if((tipo=="E") || (tipo=="R")) {
			document.getElementById('trNombreCompleto#Attributes.sufijo#').style.display=''; 		<!--- Nombre Completo --->
			document.getElementById('Juridic#Attributes.sufijo#').style.display='none';				<!--- Razon Social --->
			document.getElementById('paisOrL#Attributes.sufijo#').style.display='';					<!--- Etiqueta Pais --->
			document.getElementById('paisOrT#Attributes.sufijo#').style.display='';					<!--- Campo Pais --->
		}
	}
	
	function Cargar_datos_OnlyLocation(){
		
			/***--se carga los valores iniciales de telefonos--****/
		var fv = document.all.Ptelefono1.value;
		if(fv.length > 0)
			document.all._Ptelefono1.value = textToMask(fv);
		fv = document.all.Ptelefono2.value;
		if(fv.length > 0)
			document.all._Ptelefono2.value = textToMask(fv);	
		fv = document.all.Pfax.value;
		if(fv.length > 0)
			document.all._Pfax.value = textToMask(fv);
		/*****Fin de carga****/
	
	}
	
	function validateMask#Attributes.sufijo#(obj, aux){
		var r = "<cfoutput>#mask#</cfoutput>";
		
		
		if(r.length==0)
			return true;
		else if (obj.value.length != aux.value.length) {
			aux.value = "";
			obj.value = "";
			alert("Ingreso no valido");	
			return true;		
		}else if(r.length == obj.value.length)
			return true;
		if(aux.value.length > 0){
			aux.value = "";
			obj.value = "";
			alert("El número digitado no corresponde con la máscara");
			return true;
		}else{			
			aux.value = "";
			obj.value = "";
			
			return true;
		}
		return false;
	}
	
	function textToMask#Attributes.sufijo#(v){
		var r = "<cfoutput>#mask#</cfoutput>";
		var re = new RegExp("##");
		
		if(r.length == 0) return v;
		
		if(v.length == 0) return "";
		
		var c = "";
		for(i=0;i<v.length;i++){
				c = v.substr(i,1);
				r = r.replace(re,c);
		}
		for(i=0;(i<r.length && r.substr(i,1)!="##");i++);
		
		return r.substring(0,i);
	}
	
	function filtraChars#Attributes.sufijo#(e, obj, aux){
		var m = "<cfoutput>#mask#</cfoutput>";
		var cl = e.keyCode;
		if(obj.value.length <= m.length && !e.shiftKey){
			
			if((cl > 47)&&(cl<58)){
				aux.value += String.fromCharCode(cl);
				obj.value = textToMask#Attributes.sufijo#(aux.value);
			}else if((cl > 95)&&(cl<106)){
				aux.value += String.fromCharCode(cl-48);
				obj.value = textToMask#Attributes.sufijo#(aux.value);
			}else if(cl==8){
					aux.value=aux.value.substring(0,aux.value.length-1);
					obj.value = textToMask#Attributes.sufijo#(aux.value);
				}
				else
					obj.value = textToMask#Attributes.sufijo#(aux.value);
			
		}else{
			obj.value=obj.value.substring(0,obj.value.length-1);
		}
	}
		
	function funcionesOnchange#Attributes.sufijo#(){
		
		esJuridica#Attributes.sufijo#(document.#Attributes.form#.Ppersoneria#Attributes.sufijo#);
		
		<!--- Funcion del Tag de Atributos Extendidos --->
		var personeria = document.#Attributes.form#.Ppersoneria#Attributes.sufijo#.value;
		var id = document.#Attributes.form#.Pquien#Attributes.sufijo#.value;
		MostrarCampos#Attributes.sufijo#((personeria=='F'?'1':(personeria=='J'?'2':'')));
		ActualizaValoresExtendidos#Attributes.sufijo#((personeria=='F'?'1':(personeria=='J'?'2':'')),id);
		validar_identificacion#Attributes.sufijo#();
	}
	<cfif not Attributes.showOnlyLocation> 
		funcionesOnchange#Attributes.sufijo#();
	<cfelse>
		Cargar_datos_OnlyLocation();
	</cfif>
	
	
	/*	-------------------------	VALIDACION DE DIRECCION DE CORREO	--------------------------*/

	function emailCheck#Attributes.sufijo# (emailStr) {
		if(emailStr == '')
			return true;
		emailStr = emailStr.toLowerCase();
		/* The following variable tells the rest of the function whether or not
		to verify that the address ends in a two-letter country or well-known
		TLD.  1 means check it, 0 means don't. */
		var checkTLD=1;
		/* The following is the list of known TLDs that an e-mail address must end with. */
		var knownDomsPat=/^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/;
		/* The following pattern is used to check if the entered e-mail address
		fits the user@domain format.  It also is used to separate the username
		from the domain. */
		var emailPat=/^(.+)@(.+)$/;
		/* The following string represents the pattern for matching all special
		characters.  We don't want to allow special characters in the address. 
		These characters include ( ) < > @ , ; : \ " . [ ] */
		var specialChars="\\(\\)><@,;:\\\\\\\"\\.\\[\\]";
		/* The following string represents the range of characters allowed in a 
		username or domainname.  It really states which chars aren't allowed.*/
		var validChars="\[^\\s" + specialChars + "\]";
		/* The following pattern applies if the "user" is a quoted string (in
		which case, there are no rules about which characters are allowed
		and which aren't; anything goes).  E.g. "jiminy cricket"@disney.com
		is a legal e-mail address. */
		var quotedUser="(\"[^\"]*\")";
		/* The following pattern applies for domains that are IP addresses,
		rather than symbolic names.  E.g. joe@[123.124.233.4] is a legal
		e-mail address. NOTE: The square brackets are required. */
		var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
		/* The following string represents an atom (basically a series of non-special characters.) */
		var atom=validChars + '+';
		/* The following string represents one word in the typical username.
		For example, in john.doe@somewhere.com, john and doe are words.
		Basically, a word is either an atom or quoted string. */
		var word="(" + atom + "|" + quotedUser + ")";
		// The following pattern describes the structure of the user
		var userPat=new RegExp("^" + word + "(\\." + word + ")*$");
		/* The following pattern describes the structure of a normal symbolic
		domain, as opposed to ipDomainPat, shown above. */
		var domainPat=new RegExp("^" + atom + "(\\." + atom +")*$");
		/* Finally, let's start trying to figure out if the supplied address is valid. */
		/* Begin with the coarse pattern to simply break up user@domain into
		different pieces that are easy to analyze. */
		var matchArray=emailStr.match(emailPat);
		if (matchArray==null) {
		/* Too many/few @'s or something; basically, this address doesn't
		even fit the general mould of a valid e-mail address. */
		alert("La dirección de correo esta incorrecta (revice @ y .'s)");
		return false;
		}
		var user=matchArray[1];
		var domain=matchArray[2];
		
		// Start by checking that only basic ASCII characters are in the strings (0-127).
		
		for (i=0; i<user.length; i++) {
		if (user.charCodeAt(i)>127) {
		alert("El nombre de usuario en la dirección de correo contiene caracteres inválidos.");
		return false;
		   }
		}
		for (i=0; i<domain.length; i++) {
		if (domain.charCodeAt(i)>127) {
		alert("El nombre del dominio en la dirección de correo contiene caracteres inválidos.");
		return false;
		   }
		}
		
		// See if "user" is valid 
		
		if (user.match(userPat)==null) {
		
		// user is not valid
		
		alert("El nombre de usuario en la dirección de correo no es válido.");
		return false;
		}
		
		/* if the e-mail address is at an IP address (as opposed to a symbolic
		host name) make sure the IP address is valid. */
		
		var IPArray=domain.match(ipDomainPat);
		if (IPArray!=null) {
		
		// this is an IP address
		
		for (var i=1;i<=4;i++) {
		if (IPArray[i]>255) {
		alert("La dirección IP de destino en la dirección de correo es inválida!");
		return false;
		   }
		}
		return true;
		}
		
		// Domain is symbolic name.  Check if it's valid.
		 
		var atomPat=new RegExp("^" + atom + "$");
		var domArr=domain.split(".");
		var len=domArr.length;
		for (i=0;i<len;i++) {
		if (domArr[i].search(atomPat)==-1) {
		alert("El nombre del dominio en la dirección de correo no es válido.");
		return false;
		   }
		}
		
		/* domain name seems valid, but now make sure that it ends in a
		known top-level domain (like com, edu, gov) or a two-letter word,
		representing country (uk, nl), and that there's a hostname preceding 
		the domain or country. */
		
		if (checkTLD && domArr[domArr.length-1].length!=2 && 
		domArr[domArr.length-1].search(knownDomsPat)==-1) {
		alert("La dirección de correo debería terminar en un dominio bien conocido o en dos letras del país.");
		return false;
		}
		
		// Make sure there's a host name preceding the domain.
		
		if (len<2) {
		alert("Se olvidó de digitar el nombre del host para la dirección de correo!");
		return false;
		}
		
		// If we've gotten this far, everything's valid!
		return true;
	}
	/*	-------------------------	FIN DE VALIDACION DE DIRECCION DE CORREO	--------------------------*/


	/***--se carga los valores iniciales de telefonos--****/
	var fv = document.all.Ptelefono1#Attributes.sufijo#.value;
	if(fv.length > 0)
		document.all._Ptelefono1#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
	fv = document.all.Ptelefono2#Attributes.sufijo#.value;
	if(fv.length > 0)
		document.all._Ptelefono2#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);	
	fv = document.all.Pfax#Attributes.sufijo#.value;
	if(fv.length > 0)
		document.all._Pfax#Attributes.sufijo#.value = textToMask#Attributes.sufijo#(fv);
	/*****Fin de carga****/
	</cfoutput>
</script>
