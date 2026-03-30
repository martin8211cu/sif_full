	<cfset Session.debug = true>
	<cfif isdefined("Url.Mnombre_filtro") and not isdefined("Form.Mnombre_filtro")>
		<cfparam name="Form.Mnombre_filtro" default="#Url.Mnombre_filtro#">
	</cfif>

	<cfset select = "">
	<cfset irA = "">
	<cfset keys = "">
	<cfset from   = "">	
	<cfset where  = " Ecodigo = #session.Ecodigo#">	
	
	<cfif form.TP EQ 'A'>		<!--- Alumno --->
		<cfset select = "convert(varchar,Apersona) as Apersona, ">
		<cfset from   = "Alumno" >		
		<cfset irA = "alumno.cfm">		
		<cfset keys = "Apersona">
	<cfelseif form.TP EQ 'DO'>	<!--- Docente --->
		<cfset select = "convert(varchar,DOpersona) as DOpersona, ">
		<cfset from   = "Docente" >
		<cfset irA = "docente.cfm">
		<cfset keys = "DOpersona">				
	<cfelseif form.TP EQ 'DI'>	<!--- Director --->					
		<cfset select = "convert(varchar,DIpersona) as DIpersona, ">
		<cfset from   = "Director" >		
		<cfset irA = "director.cfm">		
		<cfset keys = "DIpersona">		
	<cfelseif form.TP EQ 'PG'>	<!--- Profesor Guia --->					
		<cfset select = "convert(varchar,PGpersona) as PGpersona, ">
		<cfset from   = "ProfesorGuia" >		
		<cfset irA = "profGuia.cfm">		
		<cfset keys = "PGpersona">		
	</cfif>
	
	<cfset select = select & "
			(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as PnombreCompleto
			, Pnombre
			, case 	when 1=1 then 'Activo'			
					when 1=0 then 'Inactivo'
			end activo
			, TP='#form.TP#'">
	<cfset filtro = "">				
	<cfset navegacion = "">
	<cfif isdefined("form.Mnombre_filtro") and len(trim(form.Mnombre_filtro)) gt 0>
		<cfset filtro = filtro & " and Upper(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) like Upper('%#form.Mnombre_filtro#%')">				
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre_filtro=" & Form.Mnombre_filtro>
	</cfif>
	<cfset navegacion = Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TP=" & Form.TP>				
	
	<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>			
	<form name="formFiltroUsuarios" method="post" action="" style="margin: 0">
		<cfoutput>
		  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##CCCCCC">
			<tr>
			  <td width="4%">&nbsp;</td>
			  <td width="50%"><strong>Nombre</strong></td>
			  <td width="12%">&nbsp;</td>
			  <td width="34%" rowspan="2" align="center" valign="middle"><input name="btnFiltro" type="submit" id="btnFiltro" value="Buscar">
			  </td>
		    </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><input name="Mnombre_filtro"  id="Mnombre_filtro" type="text" value="<cfif isdefined('form.Mnombre_filtro') and form.Mnombre_filtro NEQ ''>#form.Mnombre_filtro#</cfif>" size="80" maxlength="80"></td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
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
		<cfinvokeargument name="tabla" value="#from#"/>
		<cfinvokeargument name="columnas" value="#select#"/>
		<cfinvokeargument name="desplegar" value="PnombreCompleto,activo"/>
		<cfinvokeargument name="etiquetas" value="Nombre, Estado"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="
										#where# 
										#filtro#
									order by Pnombre"/>
		<cfinvokeargument name="align" value="left, center"/>
		<cfinvokeargument name="ajustar" value="S,S"/>
		<cfinvokeargument name="keys" value="#keys#"/>
		<cfinvokeargument name="irA" value="#irA#"/>
		<cfinvokeargument name="Botones" value="Nuevo"/>
		<cfinvokeargument name="debug" value="N"/>				
		<cfinvokeargument name="formName" value="formListaPersonas"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>			   
	
	<script language="JavaScript" type="text/javascript">
		function funcNuevo(){
			document.formListaPersonas.TP.value= '<cfoutput>#form.TP#</cfoutput>';						
		}		
	</script>