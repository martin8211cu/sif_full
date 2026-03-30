
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Identificacion"
Default="Identificaci&oacute;n"
XmlFile="/sif/rh/generales.xml"		
returnvariable="vIdentificacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombre"
Default="Nombre"
XmlFile="/sif/rh/generales.xml"		
returnvariable="vNombre"/>
	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="BTN_Fecha_de_Liquidacion"
Default="Fecha de Liquidaci&oacute;n"
returnvariable="vFechaLiq"/>

<cfquery name="rsListaLiquidaciones" datasource="#session.DSN#">
	select 1 as paso, a.DLlinea, a.DEid, RHLPestado, fechaalta, 
			{fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as nombre,
			b.DEidentificacion, 'ALTA'  as modo,
			c.DLfvigencia
			
	from RHLiquidacionPersonal a
		
		inner join DatosEmpleado b
			on a.Ecodigo = b.Ecodigo
			and a.DEid = b.DEid
		<cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion))>
			and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fDEidentificacion#">
		</cfif>
		<cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre))>
			and upper({fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )}) like '%#Ucase(Trim(form.fDEnombre))#%'
		</cfif>

		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
		<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde)) and isdefined("form.Fhasta") and len(trim(form.Fhasta))>
			and c.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fdesde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fhasta)#">
		<cfelseif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
			and c.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fdesde)#">
		<cfelseif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
			and c.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.Fhasta)#">
		</cfif>

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHLPestado = 1
	order by 9, 7, 6
</cfquery> 

<cfset navegacion = "">
<table border="0" width="100%">
	 <tr>
		<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Lista de Funcionarios Cesados</strong></td>
	 </tr>
	<tr>
		<td>
            <form name="filtro" action="" method="post">
			<table class="areaFiltro" width="100%">
				<tr>
					<td  align="right">
						<strong>Identificación:</strong>
					</td>
					<td>
						<input name="fDEidentificacion" type="text" size="20" maxlength="60" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDEidentificacion")><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>">
					</td>
					<td align="right">
						<strong>Nombre:</strong>
					</td>
					<td>
						<input name="fDEnombre" type="text" size="40" maxlength="80" align="middle" onFocus="this.select();" value="<cfif isdefined("form.fDEnombre")><cfoutput>#form.fDEnombre#</cfoutput></cfif>">
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right">
						<strong>Fecha desde:</strong>
					</td>
					<td>
						<cfset FechaDesde = "">
							<cfif not isdefined("Form.Fdesde")>
								<cfset Form.Fdesde = LSDateFormat(CreateDate(Year(Now()), Month(Now()), 1), 'dd/mm/yyyy')>
								<cfset FechaDesde = Form.Fdesde>
							<cfelse>
								<cfset FechaDesde = Form.Fdesde>
							</cfif>
							<cf_sifcalendario form="filtro" name="Fdesde" value="#FechaDesde#">
					</td>
					<td nowrap="nowrap" align="right">
						<strong>Fecha hasta:</strong>
					</td>
					<td>
						<cfset FechaHasta = "">
							<cfif not isdefined("Form.Fhasta")>
								<cfset Form.Fhasta = LSDateFormat(Now(), 'dd/mm/yyyy')>
								<cfset FechaHasta = Form.Fhasta>
							<cfelse>
								<cfset FechaHasta = Form.Fhasta>
							</cfif>
							<cf_sifcalendario form="filtro" name="Fhasta" value="#FechaHasta#">
					</td>
					<td>
						<cf_botones names="Filtrar" values="Filtrar">
					</td>
				</tr>
			</table>
            </form>
		</td>
	</tr>

	<tr>
		<td align="center">
			 <cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaLiquidaciones#"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion, nombre, DLfvigencia "/>
					<cfinvokeargument name="etiquetas" value="#vIdentificacion#, #vNombre#, #vFechaLiq#"/>
					<cfinvokeargument name="formatos" value="S, S, D"/>
					<cfinvokeargument name="align" value="left, left, center "/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="keys" value="DLlinea"/> 
					<cfinvokeargument name="showEmptyListMsg" value= "1"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="botones" value=""/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="irA" value= "recalculo.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
	</tr>
</table>