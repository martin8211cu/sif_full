<cfif not isdefined("url.Formato")>
	<cfset url.Formato = 'flashpaper'>
</cfif>
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfquery name="RSperiodos" datasource="#Session.Dsn#">
	select distinct  AFMovsPeriodo  as value, <cf_dbfunction name="to_char" args="AFMovsPeriodo"> as description , 0
	from AFMovsEmpresasE 
	where Ecodigo = #session.Ecodigo#
	union select -1, '--Todos--', -1
	from dual
	order by 3
</cfquery>	

<cfquery name="RSMeses" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="b.VSvalor"> as value, VSdesc as description,0
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
		and <cf_dbfunction name="to_number" args="b.VSvalor"> in (
			select distinct AFMovsMes 
			from AFMovsEmpresasE  x
				where x.Ecodigo  = #session.Ecodigo#
		)	
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
	union select -1, '--Todos--', -1
	from dual
	order by 3
</cfquery>	

<cfif not isdefined("form.filtro_AFMovsDescripcion") and isdefined("url.filtro_AFMovsDescripcion")>
	<cfset form.filtro_AFMovsDescripcion = url.filtro_AFMovsDescripcion>
</cfif>	
<cfif not isdefined("form.filtro_Periodo") and isdefined("url.filtro_Periodo")>
	<cfset form.filtro_Periodo = url.filtro_Periodo>
</cfif>	
<cfif not isdefined("form.filtro_Mes") and isdefined("url.filtro_Mes")>
	<cfset form.filtro_Mes= url.filtro_Mes>
</cfif>	
<cfif not isdefined("form.filtro_AFMovsFechaPosteo") and isdefined("url.filtro_AFMovsFechaPosteo")>
	<cfset form.filtro_AFMovsFechaPosteo = url.filtro_AFMovsFechaPosteo>
</cfif>	



<cfquery name="rsLista" datasource="#session.dsn#">
		select 
		AFMovsID,
		AFMovsDescripcion,
		AFMovsPeriodo,
		case AFMovsMes 
		when 1 then  'Enero'
		when 2 then  'Febrero'
		when 3 then  'Marzo'
		when 4 then  'Abril'
		when 5 then  'Mayo'
		when 6 then  'Junio'
		when 7 then  'julio'
		when 8 then  'Agosto'
		when 9 then  'Setiembre'
		when 10 then 'Octubre'
		when 11 then 'Noviembre'
		when 12 then 'Diciembre'
		end as AFMovsMes,
		AFMovsFechaPosteo,
		'#url.Formato#' as formato   
		from AFMovsEmpresasE
		where AFMovsEstado  = 1
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.filtro_AFMovsDescripcion") and len(trim(url.filtro_AFMovsDescripcion))>
			and ltrim(rtrim(upper(AFMovsDescripcion))) like '%#trim(ucase(url.filtro_AFMovsDescripcion))#%'
		</cfif>
		<cfif isdefined("form.filtro_Periodo") and len(trim(form.filtro_Periodo)) and form.filtro_Periodo neq '-1'>
			and AFMovsPeriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_Periodo#">
		</cfif>
		<cfif isdefined("form.filtro_Mes") and len(trim(form.filtro_Mes)) and form.filtro_Mes neq '-1'>
			and AFMovsMes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_Mes#">
		</cfif>
		<cfif isdefined("url.filtro_AFMovsFechaPosteo") and len(trim(url.filtro_AFMovsFechaPosteo))>
			and AFMovsFechaPosteo >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedatetime(url.filtro_AFMovsFechaPosteo)#">

		</cfif>
</cfquery>	

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<form action="AF_ListaTrasladosRep.cfm"  method="get" name="form1" id="form1">
			<cfoutput>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="10%" align="left" valign="bottom" class="tituloListas">Formato</td>
					<td width="40%" align="left" valign="bottom" class="tituloListas">Descripción</td>
					<td width="15%" align="left" valign="bottom" class="tituloListas">Periodo</td>
					<td width="15%" align="left" valign="bottom" class="tituloListas">Mes</td>
					<td width="15%" align="left" valign="bottom" class="tituloListas">Fecha</td>
					<td width="5%" align="left" valign="bottom" class="tituloListas">&nbsp;</td>
				</tr>
				<tr>
					<td class="tituloListas" align="left" valign="bottom">
					<select name="Formato" id="Formato" tabindex="1" onchange="document.form1.submit();">
						<option value="flashpaper" <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato eq 'flashpaper'>selected</cfif>>FLASHPAPER</option>
						<option value="pdf" <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato eq 'pdf'>selected</cfif>>PDF</option>
						<option value="xls" <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato eq 'xls'>selected</cfif>>EXCEL</option>
					</select>	
					</td>
					<td class="tituloListas" align="left" valign="bottom">
					<input type="text" size="70" maxlength="70" tabindex="2"style="width:100%" onfocus="this.select()" 
						name="filtro_AFMovsDescripcion" value="<cfif isdefined("url.filtro_AFMovsDescripcion") and len(trim(url.filtro_AFMovsDescripcion))>#url.filtro_AFMovsDescripcion#</cfif>">
					</td>
					<td align="left" valign="bottom" class="tituloListas">
						<select name="filtro_Periodo" tabindex="3">
							<cfloop query="RSperiodos">
								<option value="#value#" <cfif isdefined("url.filtro_Periodo") and len(trim(url.filtro_Periodo)) and url.filtro_Periodo eq value> selected</cfif> >#description#</option>
							</cfloop>
						</select>					
					</td>
					<td align="left" valign="bottom" class="tituloListas">
						<select name="filtro_Mes" tabindex="4">
							<cfloop query="RSMeses">
								<option value="#value#" <cfif isdefined("url.filtro_Mes") and len(trim(url.filtro_Mes)) and url.filtro_Mes eq value> selected</cfif> >#description#</option>
							</cfloop>
						</select>					
					</td>
					<td align="left" valign="bottom" class="tituloListas"><cf_sifcalendario name="filtro_AFMovsFechaPosteo" value=""  tabindex="5"></td>
					<td align="left" valign="bottom" class="tituloListas">
						<cf_botones values="Filtrar" names="Filtrar" tabindex="6">
					</td>
				</tr> 
				</form>
				<tr>
					<td  colspan="6">
						<cfinvoke component="sif.Componentes.pListas"method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"     		  value="#rsLista#"/>
							<cfinvokeargument name="desplegar" 		  value="AFMovsDescripcion,AFMovsPeriodo,AFMovsMes,AFMovsFechaPosteo"/>
							<cfinvokeargument name="etiquetas" 		  value="Descripción,Periodo,Mes,Fecha de Aplicación"/>
							<cfinvokeargument name="formatos" 		  value="S,S,S,D"/>
							<cfinvokeargument name="align" 			  value="left,left,left,center"/>
							<cfinvokeargument name="ajustar" 		  value="N"/>
							<cfinvokeargument name="checkboxes" 	  value="N"/>
							<cfinvokeargument name="irA" 			  value="AF_TrasladosAplicadosREP.cfm"/>
							<cfinvokeargument name="keys" 		      value="AFMovsID,formato"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="form_method" 	  value="GET">
						</cfinvoke>
					</td>
				</tr>									
			</table>	
			</cfoutput>							
	<cf_web_portlet_end>
<cf_templatefooter> 