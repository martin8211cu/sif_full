<!---  	<cfquery name="rsEstrOrganiz" datasource="#session.DSN#">
		Select convert(varchar,ESOcodigo) as ESOcodigo
			, convert(varchar(30),ESOnombre) + case when datalength(ESOnombre) > 30 then '...' end as ESOnombre
		from EstructuraOrganizacional
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and ESOultimoNivel = 1
		order by ESOnombre
	</cfquery> --->	
	<cfset session.TABS.TabsMateria = 1>
	<cfinclude template="/educ/queries/qryEscuela.cfm">	
	
	
	<cfquery name="qryGradoAcad" datasource="#Session.DSN#">
		select convert(varchar, GAcodigo) as GAcodigo, GAnombre 
		from GradoAcademico
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		order by GAorden, GAnombre
	</cfquery>				
	
	<cfif isdefined("Url.Mcodificacion_filtro") and not isdefined("Form.Mcodificacion_filtro")>
		<cfparam name="Form.Mcodificacion_filtro" default="#Url.Mcodificacion_filtro#">
	</cfif>
	<cfif isdefined("Url.Mnombre_filtro") and not isdefined("Form.Mnombre_filtro")>
		<cfparam name="Form.Mnombre_filtro" default="#Url.Mnombre_filtro#">
	</cfif>
	<cfif isdefined("Url.EScodigo_filtro") and not isdefined("Form.EScodigo_filtro")>
		<cfparam name="Form.EScodigo_filtro" default="#Url.EScodigo_filtro#">
	</cfif>
	<cfif isdefined("Url.GAcodigo_filtro") and not isdefined("Form.GAcodigo_filtro")>
		<cfparam name="Form.GAcodigo_filtro" default="#Url.GAcodigo_filtro#">
	</cfif>												
	<cfif isdefined("Url.Mcreditos_filtro") and not isdefined("Form.Mcreditos_filtro")>
		<cfparam name="Form.Mcreditos_filtro" default="#Url.Mcreditos_filtro#">
	</cfif>					

	<cfset navegacion = "">
	<cfset filtro = " and Mtipo='#form.T#'">				
	<cfif isdefined("form.Mcodificacion_filtro") and len(trim(form.Mcodificacion_filtro)) gt 0>
		<cfset filtro = filtro & " and Upper(Mcodificacion) like Upper('%#form.Mcodificacion_filtro#%')">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodificacion_filtro=" & Form.Mcodificacion_filtro>
	</cfif>			
	<cfif isdefined("form.Mnombre_filtro") and len(trim(form.Mnombre_filtro)) gt 0>
		<cfset filtro = filtro & " and Upper(Mnombre) like Upper('%#form.Mnombre_filtro#%')">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre_filtro=" & Form.Mnombre_filtro>
	</cfif>
	<cfif isdefined("form.EScodigo_filtro") and len(trim(form.EScodigo_filtro)) gt 0 and form.EScodigo_filtro NEQ '-1'>
		<cfset filtro = filtro & " and EScodigo=#form.EScodigo_filtro#">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EScodigo_filtro=" & Form.EScodigo_filtro>
	</cfif>
	<cfif isdefined("form.GAcodigo_filtro") and len(trim(form.GAcodigo_filtro)) gt 0 and form.GAcodigo_filtro NEQ '-1'>
		<cfset filtro = filtro & " and GAcodigo=#form.GAcodigo_filtro#">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GAcodigo_filtro=" & Form.GAcodigo_filtro>
	</cfif>				
	<cfif isdefined("form.Mcreditos_filtro") and len(trim(form.Mcreditos_filtro)) gt 0>
		<cfset filtro = filtro & " and Mcreditos=#form.Mcreditos_filtro#">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcreditos_filtro=" & Form.Mcreditos_filtro>
	</cfif>				
				
	<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>			
	<form name="formFiltroMaterias" method="post" action="" style="margin: 0">
		<cfoutput>
		  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##CCCCCC">
					  
			<tr>
			  <td width="2%">&nbsp;</td>
			  <td width="19%"><strong>C&oacute;digo</strong></td>
			  <td width="3%">&nbsp;</td>
			  <td width="27%"><strong>Nombre</strong></td>
			  <td width="6%">&nbsp;</td>
			  <td width="28%"><strong>#session.parametros.creditos#</strong></td>
		    </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><input name="Mcodificacion_filtro" type="text" id="Mcodificacion_filtro" tabindex="1" value="<cfif isdefined('form.Mcodificacion_filtro') and form.Mcodificacion_filtro NEQ ''>#form.Mcodificacion_filtro#</cfif>" size="15" maxlength="15" alt="El c&oacute;digo de la materia"></td>
			  <td>&nbsp;</td>
			  <td><input name="Mnombre_filtro"  id="Mnombre_filtro2" type="text" value="<cfif isdefined('form.Mnombre_filtro') and form.Mnombre_filtro NEQ ''>#form.Mnombre_filtro#</cfif>" size="50" maxlength="50" tabindex="1" alt="La descripci&oacute;n de la materia"></td>
			  <td>&nbsp;</td>
			  <td><input name="Mcreditos_filtro" style="text-align: right;" type="text" id="Mcreditos_filtro2" size="10" maxlength="8" value="<cfif isdefined('form.Mcreditos_filtro') and form.Mcreditos_filtro NEQ ''>#form.Mcreditos_filtro#</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><strong>#session.parametros.Escuela#</strong></td>
			  <td>&nbsp;</td>
			  <td><strong>Grado Acad&eacute;mico</strong></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>			  
				<select name="EScodigo_filtro" id="EScodigo_filtro">
					<option value="-1" <cfif isdefined('form.EScodigo_filtro') and form.EScodigo_filtro EQ '-1'> selected</cfif>>--
					TODAS --</option>			
				  <cfloop query="rsEscuela">
					<option value="#rsEscuela.EScodigo#" <cfif isdefined('form.EScodigo_filtro') and form.EScodigo_filtro EQ rsEscuela.EScodigo> selected</cfif>>#rsEscuela.ESnombre#</option>
				  </cfloop>
				</select>			  
			  </td>
			  <td>&nbsp;</td>
				<td>
					<select name="GAcodigo_filtro" id="GAcodigo_filtro">
						<option value="-1" >-- Todos --</option>
						<cfloop query="qryGradoAcad">
							<option value="#qryGradoAcad.GAcodigo#" <cfif isdefined('form.GAcodigo_filtro') and form.GAcodigo_filtro EQ qryGradoAcad.GAcodigo> selected</cfif>>#qryGradoAcad.GAnombre#</option>
						</cfloop>
					</select>						
				</td>
				<td>&nbsp;</td>
				<td align="center"><input name="btnFiltro" type="submit" id="btnFiltro" value="Buscar"></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
		  </table>
		</cfoutput>
	</form>	   
	  
	<cfinvoke component="educ.componentes.pListas" 
			  method="pListaEdu" 
			  returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="Materia"/>
		<cfinvokeargument name="columnas" value="
			convert(varchar,Mcodigo) as Mcodigo
			  , case Mtipo
				when 'M' then 'Regular' 
				when 'E' then 'Electiva'
			  end as Mtipo
			, Mcodificacion
			, Mnombre
			, Mcreditos
			, Mrequisitos
			, T='#form.T#'"/>
		<cfinvokeargument name="desplegar" value="Mcodificacion, Mnombre, Mcreditos, Mrequisitos"/>
		<cfinvokeargument name="etiquetas" value="C&oacute;digo, Nombre, #session.Parametros.creditos#, Requisitos"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="
				Ecodigo=#session.Ecodigo# 
				and Mtipo in ('M','E')
				#filtro#
			order by Mcodificacion, Mnombre"/>
		<cfinvokeargument name="align" value="left,left,left,left"/>
		<cfinvokeargument name="ajustar" value="S,S,S,S"/>
		<cfinvokeargument name="keys" value="Mcodigo"/>
		<cfinvokeargument name="irA" value="materia.cfm"/>
		<cfinvokeargument name="Botones" value="Nueva"/>
		<cfinvokeargument name="debug" value="N"/>				
		<cfinvokeargument name="MaxRows" value="5"/>
		<cfinvokeargument name="formName" value="formListaMaterias"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>			   

	
	<script language="JavaScript" type="text/javascript">
		function funcNueva(){
			document.formListaMaterias.MCODIGO.value= '';
			document.formListaMaterias.T.value= '<cfoutput>#form.T#</cfoutput>';			
		}		
	</script>