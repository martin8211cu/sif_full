<cf_templateheader title="Punto de Venta - Denominaciones de Monedas">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Denominaciones de Monedas">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfif isdefined('url.Mcodigo_F') and not isdefined('form.Mcodigo_F')>
					<cfparam name="form.Mcodigo_F" default="#url.Mcodigo_F#">
				</cfif>
				<cfif isdefined('url.FAM24DES_F') and not isdefined('form.FAM24DES_F')>
					<cfparam name="form.FAM24DES_F" default="#url.FAM24DES_F#">
				</cfif>

				<cfinclude template="den_monedas-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.Mcodigo_F") and Len(Trim(Form.Mcodigo_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo_F=" & Form.Mcodigo_F>
				</cfif>				
				<cfif isdefined("Form.FAM24DES_F") and Len(Trim(Form.FAM24DES_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM24DES_F=" & Form.FAM24DES_F>
				</cfif>
		
				<cfquery name="lista" datasource="#session.DSN#">
					select 
						case FAM24TIP 
							when 'B' then 'Billetes'	
							when 'M' then 'Monedas'
	    				end FAM24TIPdesc, 
						FAM24TIP,
						a.FAM24VAL, 
						a.Mcodigo, 
						a.FAM24DES, 
						b.Miso4217
					
					<cfif isdefined("Form.Mcodigo_F") and Len(Trim(Form.Mcodigo_F)) NEQ 0>
						, '#Mcodigo_F#' as Mcodigo_F
					</cfif>	
					<cfif isdefined("Form.FAM24DES_F") and Len(Trim(Form.FAM24DES_F)) NEQ 0>
						, '#FAM24DES_F#' as FAM24DES_F
					</cfif>		
							
					from FAM024 a
					
					inner join Monedas b 
					on a.Mcodigo = b.Mcodigo 
					
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.Mcodigo_F') and form.Mcodigo_F NEQ ''>
						and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo_F#">
					</cfif>
					<cfif isdefined('form.FAM24DES_F') and form.FAM24DES_F NEQ ''>
						and upper(FAM24DES) like upper('%#form.FAM24DES_F#%')
					</cfif>	
					 
					order by a.FAM24DES
				</cfquery>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="Miso4217,FAM24DES, FAM24TIPdesc, FAM24VAL"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Tipo, Valor"/>
					<cfinvokeargument name="formatos" value="V, V, V, M"/>
					<cfinvokeargument name="align" value="left, left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="den_monedas.cfm"/>
					<cfinvokeargument name="keys" value="FAM24TIP, FAM24VAL, Mcodigo"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="den_monedas-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>