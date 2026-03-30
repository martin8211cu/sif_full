<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ClasificacionesLocales" default = "Clasificaciones Locales" returnvariable="LB_ClasificacionesLocales" xmlfile = "SociosClasif.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ClasificacionesCorporativas" default = "Clasificaciones Corporativas" returnvariable="LB_ClasificacionesCorporativas" xmlfile = "SociosClasif.xml">


<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Ttercero" default = "TIPO DE TERCERO" returnvariable="LB_Ttercero" xmlfile = "SociosClasif.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ToperD" default = "TIPO DE OPERACION" returnvariable="LB_ToperD" xmlfile = "SociosClasif.xml">


<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Ninguno" default = "Ninguno" returnvariable="LB_Ninguno" xmlfile = "SociosClasif.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DebeEscogerUno" default = "Debe Escoger uno" returnvariable="LB_DebeEscogerUno" xmlfile = "SociosClasif.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NoHayClasificacionesDefinidas" default = "No hay clasificaciones definidas" returnvariable="LB_NoHayClasificacionesDefinidas" xmlfile = "SociosClasif.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_HagaClicAquiParaDefinirlas" default = "Haga clic aqu&iacute; para definirlas" returnvariable="LB_HagaClicAquiParaDefinirlas" xmlfile = "SociosClasif.xml">

<cfquery datasource="#session.dsn#" name="infSN">
	SELECT g.SNtiposocio
	  FROM SNegocios g
	  WHERE SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
</cfquery>

<cfquery datasource="#session.dsn#" name="clases">
	select e.SNCEid, e.SNCEcorporativo, 
		e.SNCEcodigo, e.SNCEdescripcion, e.PCCEobligatorio,
		d.SNCDid , d.SNCDvalor, d.SNCDdescripcion, 
		case when e.Ecodigo is null then 0 else 1 end as local,
		case when sn.SNCDid is null then 0 else 1 end as existe
	from SNClasificacionE e
		join SNClasificacionD d
			on d.SNCEid = e.SNCEid
		left join SNClasificacionSN sn
			on sn.SNCDid = d.SNCDid
			and sn.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
	where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and ( e.Ecodigo is null or e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	  and e.PCCEactivo = 1
	  <cfif infSN.SNtiposocio EQ 'A'>
	  AND e.SNCtiposocio in ('C','P','A')
	  <cfelse>
	   AND e.SNCtiposocio in ('#infSN.SNtiposocio#','A' )
	  </Cfif>
	  <cfif isDefined('moduloCred') and moduloCred eq 1>
			and e.SNCredyC = 1
	  </cfif>
	  	
	order by local, e.SNCEcodigo, e.SNCEdescripcion, e.SNCEid, 
		d.SNCDdescripcion 
</cfquery>

<cfquery datasource="#session.dsn#" name="rsBDiotO">
	select DIOTopcodigo
	from SNDIOTOper
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNcodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="rsDiotT">
	select DIOTcodigo
	from SNDIOTClas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNcodigo#">
</cfquery>


<cfquery datasource="#session.dsn#" name="rsDiotS">
	select DIOTcodigo,DIOTdesc
	from DIOTsocio	
</cfquery>

<cfquery datasource="#session.dsn#" name="rsDiotO">
	select DIOTopcodigo,DIOTopdesc
	from DIOToperacion	
</cfquery>

<form action="/cfmx/sif/ad/catalogos/SociosClasif-sql.cfm" method="post" style="margin:0 " name="formClax">
	<cfoutput>
		<input type="hidden" name="SNid" value="#HTMLEditFormat(rsSocios.SNid)#">
		<input type="hidden" name="SNcodigo" value="#HTMLEditFormat(rsSocios.SNcodigo)#">
		<cfif isDefined('moduloCred') and moduloCred eq 1>
			<input type="hidden" name="moduloCred" id="moduloCred" value="1">
		</cfif>
	</cfoutput>

	<cfoutput query="clases" group="local">	
		<cfif rsSocios.SNtiposocio eq 'P' or rsSocios.SNtiposocio eq 'A'>			
		    <fieldset><legend>Clasificaci&oacute;n DIOT</legend>
			<table align="center">
			<tr>
			  <td width="73">&nbsp;</td>
			  <td width="247">#LB_Ttercero#</td>
			  <td width="55">&nbsp;</td>
			  <td width="311">
				<select name="TipoTD" style="width:255px;">			
					<option value="00" selected>-----Seleccione-----</option>
					<cfloop query="rsDiotS">						
						<option value="#rsDiotS.DIOTcodigo#" <cfif rsDiotT.RecordCount gt 0 and rsDiotT.DIOTcodigo eq rsDiotS.DIOTcodigo>selected</cfif>>#rsDiotS.DIOTdesc#</option>
					</cfloop>
				</select>
			</td>	
			</tr>

			<tr>
			  <td width="73">&nbsp;</td>
			  <td width="247">#LB_ToperD#</td>
			  <td width="55">&nbsp;</td>
			  <td width="311">
				<select name="TipoOD" style="width:255px;">		
					<option value="00" selected>-----Seleccione-----</option>
					<cfloop query="rsDiotO">						
						<option value="#rsDiotO.DIOTopcodigo#"<cfif rsBDiotO.RecordCount neq 0 and rsBDiotO.DIOTopcodigo eq rsDiotO.DIOTopcodigo>selected</cfif>>
						#rsDiotO.DIOTopdesc#</option>
					</cfloop>	
				</select>
				</td>	
			</tr>
		    </table>
		    </fieldset>
		</cfif>

		<table align="center">
		<tr>
			<td colspan="4" class="tituloListas">
				<cfif clases.local>#LB_ClasificacionesLocales#<cfelse>#LB_ClasificacionesCorporativas#</cfif>
			</td>
		</tr>

		<cfoutput group="SNCEid">
			<tr>
				<td width="73">&nbsp;</td>
				<td width="247">#HTMLEditFormat(SNCEdescripcion)#</td>
				<td width="55">&nbsp;</td>
				<td width="311">
				<select name="clax" style="width:255px;" <cfif SNCEcorporativo And  session.Ecodigo neq session.Ecodigocorp and Len(session.Ecodigocorp)>disabled</cfif>>
					<cfif PCCEobligatorio EQ 0>
						<option value="">-#LB_Ninguno#-</option>
					<cfelse>
						<option value="">- #LB_DebeEscogerUno# -</option>	
					</cfif>
					<cfoutput>
						<cfif existe or SNCEcorporativo EQ 0 or session.Ecodigo eq session.Ecodigocorp or not Len(session.Ecodigocorp ) >
							<option value="#HTMLEditFormat(SNCDid)#" <cfif existe>selected</cfif>>#HTMLEditFormat(SNCDdescripcion)#</option>
						</cfif>
					</cfoutput>
				</select>
			</td>
			</tr>
		</cfoutput>
		</table>
	</cfoutput>
	<table align="center">
		<cfif clases.RecordCount EQ 0>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4" align="center" style="font-size:18px;">
				<cfoutput><a href="/cfmx/sif/ad/catalogos/SNClasificaciones.cfm">#LB_NoHayClasificacionesDefinidas#.<br>#LB_HagaClicAquiParaDefinirlas#.</a>
				</cfoutput></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
		<cfelse>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr><td colspan="4">
				<cf_botones names="Cambio" values="Modificar">
			</td></tr>
		</cfif>
	</table>
</form>