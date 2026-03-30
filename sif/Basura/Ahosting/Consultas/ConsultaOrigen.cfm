<cfif isdefined("form.SDetalle")>
	<cfset LvarDetalle = form.SDetalle>
<cfelse>
	<cfset LvarDetalle = 1> <!---Para No Mostrar los Detalles --->
</cfif>

<cfif isdefined("form.Origen") and len(form.Origen) GT 0>
	<cfset LvarOrigen = form.Origen>
</cfif>
<cfif isdefined("url.Origen") and len(url.Origen) GT 0>
	<cfset LvarOrigen = url.Origen>
</cfif>

<cfif not isdefined("session.Ecodigo") OR session.Ecodigo EQ 0>
	<cfthrow message="Para Ejecutar este reporte debe iniciar Sesion en el sistema">
</cfif>

<cfif not isdefined("url.Tabla") and not isdefined("url.Externos")>
<cfif not isdefined("url.SE")>
<cf_templateheader title="Consulta Origenes">
</cfif>
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Origenes Contables'>

		<cfoutput>
			<form id="form1" name="form1" method="post" action="ConsultaOrigen.cfm">
				<table class="AreaFiltro" width="100%">
					<tr>
						<td align="center" colspan="4">
							<strong> FILTROS DE LA CONSULTA </strong>
						</td>
					</tr>
					<tr>
						<td align="left" width="10%">
							<input type="button" value="Inicio" onclick="submit()" />
						</td>
						<cfif not isdefined("url.Origen")>
							<td width="30%">
								<input type="checkbox" name="OpcionA" onclick="submit()" <cfif isdefined("form.OpcionA") and form.OpcionA EQ "on">checked="checked"</cfif>/> Solo Or&iacute;genes de Modulos Externos
							</td>
							<td width="30%">
								<input type="checkbox" name="OpcionB" onclick="submit()" <cfif isdefined("form.OpcionB") and form.OpcionB EQ "on">checked="checked"</cfif>/> Or&iacute;genes con par&aacute;metros contables 
							</td>
							<td width="30%">
								<input type="checkbox" name="OpcionC" onclick="submit()" <cfif isdefined("form.OpcionC") and form.OpcionC EQ "on">checked="checked"</cfif>/> Or&iacute;genes que apliquen a esta empresa
							</td>
						</cfif>
					</tr>
					<cfif not isdefined("url.Origen")>
					<tr>
						<td align="left" width="10%" colspan="2">
							<input type="button" value="Catalogos Externos" onclick=javascript:document.form1.action="ConsultaOrigen.cfm?Externos";submit() />
						</td>
					</tr>
					</cfif>
				</table>
			</form>
		</cfoutput>
		<cfif not isdefined("url.Origen")>
			<cfquery name="rsReporte" datasource="#session.DSN#">
				select o.Oorigen, o.Odescripcion, o.Otipo
				from Origenes o
				<cfif isdefined("form.OpcionB") and form.OpcionB EQ "on">
					inner join OrigenDocumentos od
					on o.Oorigen = od.Oorigen 
				</cfif>
				<cfif isdefined("form.OpcionC") and form.OpcionC EQ "on">
					inner join ConceptoContable cc
					on o.Oorigen = cc.Oorigen 
					and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfif>
				<cfif isdefined("form.OpcionA") and form.OpcionA EQ "on">
					where o.Otipo like 'E'
				</cfif> 
				Order by o.Otipo,o.Oorigen
			</cfquery>
			<center>
			<table width="80%" cellpadding="2" cellspacing="10" >
				<tr>
					<td bgcolor="#CCCCCC" bordercolor="#000000" align="center" width="30%"> Origen </td>
					<td align="center" width="50%"> Descripci&oacute;n </td>
					<td bgcolor="#CCCCCC" bordercolor="#000000" align="center" width="20%"> Tipo </td>
				</tr>
			</table>
			</center>
			<hr color="#333333" style="border:groove" /> 
			<cfoutput query="rsReporte" group="Oorigen">
				<center>
				<table width="80%" cellpadding="2" cellspacing="10">
					<tr>
						<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
							<a href="ConsultaOrigen.cfm?Origen=#Oorigen#" target="_self">#Oorigen#</a></td>
						<td align="center" width="50%">#Odescripcion#</td>
						<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="20%">#Otipo#</td>
					</tr>
				</table>
				</center>	
			</cfoutput>
		<cfelse>
			<cfquery name="rsReporte" datasource="#session.DSN#">
				select o.Oorigen, o.Odescripcion, o.Otipo, isnull(od.OPtablaMayor,'') as PCmayor,
					isnull(od.OPconst,'') as Cmayor
				from sif_control..Origenes o
					inner join OrigenDocumentos od
					on o.Oorigen = od.Oorigen 
				where od.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and ltrim(rtrim(o.Oorigen)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarOrigen)#">
				Order by o.Otipo,o.Oorigen
			</cfquery>
		
			<cfloop query="rsReporte">
				<cfoutput>
				<pre><strong> Origen Contable: #rsReporte.Oorigen# </strong>
				<cfif len(trim(rsReporte.PCmayor)) EQ 0>Cuenta de Mayor Estatica<cfelseif len(trim(rsReporte.CMayor)) EQ 0>Cuenta de Mayor Variable depende del Parametro<cfelse>Cuenta de Mayor No Parametrizada!!!!</cfif>:<cfif len(trim(rsReporte.PCmayor)) EQ 0>#rsReporte.Cmayor#<cfelseif len(trim(rsReporte.CMayor)) EQ 0><a href="ConsultaOrigen.cfm?Tabla=#rsReporte.PCmayor#&Origen=#Oorigen#" target="_blank">#rsReporte.PCmayor#</a><cfelse>¿¿¿???</cfif></pre>
				</cfoutput>
				<cfquery datasource="#session.DSN#" name="rsNiveles">
					select Oorigen, Cmayor,OPnivel, isnull(OPtabla,'') as OPtabla, isnull(OPconst,'') as OPconst
					from OrigenNivelProv op
					where op.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and op.Oorigen like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarOrigen)#">
				</cfquery>
				<cfoutput query="rsNiveles" group="Cmayor">
					<p style="margin-left:10em"><strong><a href="ConsultaCuentas.cfm?FCMayor=#Cmayor#" target="_blank">#Cmayor#</a></strong></p>
					<center>
					<table width="50%" border="1" cellpadding="2" cellspacing="8">
						<tr>
							<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="50%">Nivel</td>
							<td align="center" width="50%">
								Configuracion
							</td>
						</tr>
					</table>
					</center>
					<cfoutput>
						<center>
						<table width="50%" border="1" cellpadding="2" cellspacing="8">
							<tr>
								<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="50%">#OPnivel# </td>
								<td align="center" width="50%"><a href="ConsultaOrigen.cfm?Tabla=#OPtabla#&Origen=#Oorigen#&Cuenta=#Cmayor#&Nivel=#OPnivel#" target="_blank">#OPtabla#</a>#OPconst#</td>
							</tr>
						</table>
						</center>
						
					</cfoutput>
				</cfoutput>
			</cfloop>
		</cfif>
    <cf_web_portlet_end>
<cfif not isdefined("url.SE")>
<cf_templatefooter>
</cfif>
<cfelseif isdefined("url.Tabla") and not isdefined("url.Todo")>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Origenes Contables'>
	<cfif isdefined("url.Nivel")>
		<!---Longitud del nivel--->
        <cfquery name="rsLNivel" datasource="#session.DSN#">
            select isnull(pd.PCNlongitud,0) as PCNlongitud
            from CtasMayor c 
            inner join PCEMascaras pc 
                inner join PCNivelMascara pd
                on pc.PCEMid = pd.PCEMid 
            on c.PCEMid = pc.PCEMid 
            and PCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Nivel#">
            and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Cuenta)#">
            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cfset varNLongitud = rsLNivel.PCNlongitud>
        <!---Longitud Antes del nivel--->
        <cfquery name="rsANivel" datasource="#session.DSN#">
            select isnull(sum(pd.PCNlongitud),0) as Longitud
            from CtasMayor c 
            inner join PCEMascaras pc 
                inner join PCNivelMascara pd
					inner join OrigenNivelProv op 
					on pd.PCNid = op.OPnivel and c.Cmayor = op.Cmayor and op.Ecodigo = c.Ecodigo 
					and op.Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Origen)#">
					and op.OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Tabla)#">
                on pc.PCEMid = pd.PCEMid 
            on c.PCEMid = pc.PCEMid 
            and PCNid < <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Nivel#">
            and c.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Cuenta)#">
            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cfset varALongitud = rsANivel.Longitud + 1>
	</cfif>    
    <cfquery name="rsReporte" datasource="#session.DSN#">
		select o.Oorigen, o.OPtabla, o.Cmayor, ODnum, isnull(o.ODchar,'') as ODchar, 
			<cfif isdefined("url.Nivel")>
	            substring(isnull(o.ODcomplemento,''),#varALongitud#,#varNLongitud#) as ODcomplemento
            <cfelse>
            	ODcomplemento
            </cfif>
		from OrigenDatos o 
		where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.Origen")>
			and o.Oorigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Origen)#">
		</cfif>
		<cfif isdefined("url.Cuenta")>
			and o.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Cuenta)#">
			and ltrim(rtrim(isnull(o.ODcomplemento,''))) != ''
		</cfif>
		and o.OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Tabla)#">
		Order by o.Oorigen,o.ODchar, o.Cmayor
	</cfquery>
	<cfoutput query="rsReporte" group="Oorigen">
		<strong>Catalogo Externo: #trim(url.Tabla)#</strong>
		<br />
		<strong>Origen: #Oorigen#</strong>
		<cfif isdefined("url.Cuenta")>
		<br />
		<strong>Valores para la cuenta de mayor: #Cmayor# Nivel: #url.Nivel#</strong>
		<cfelse>
		<br />
		<strong>Cuentas de mayor configuradas</strong>
		</cfif>
		<cfoutput>
			<center>
			<table width="80%" cellpadding="2" cellspacing="10">
				<tr>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
						#ODchar#
					</td>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
						<cfif isdefined("url.Cuenta")>
						#ODcomplemento#
						<cfelse>
						#Cmayor#
						</cfif>
					</td>
				</tr>
			</table>
			</center>
		</cfoutput>
	</cfoutput>
<cf_web_portlet_end>
<cfelseif isdefined("url.Tabla") and isdefined("url.Todo")>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Complementos Contables'>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select o.Oorigen, o.OPtabla, o.Cmayor, ODnum, isnull(o.ODchar,'') as ODchar, 
			isnull(o.ODcomplemento,'') as ODcomplemento, isnull(ODactivo,0) as MActivo
		from OrigenDatos o 
        	left join OrigenDocumentos od on o.Ecodigo = od.Ecodigo and od.OPtablaMayor = o.OPtabla
		where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and o.OPtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.Tabla)#">
		Order by o.Oorigen,o.ODchar, o.Cmayor
	</cfquery>
	<cfoutput>
		<center><h3><strong>Catalogo <cfif url.TipoT EQ 1>Externo</cfif>: #trim(url.Tabla)#</strong></h3></center>
	</cfoutput>
	<br />
	<cfoutput query="rsReporte" group="Oorigen">
		<strong>Origen Contable: <a href="ConsultaOrigen.cfm?Origen=#Oorigen#&SE" target="_parent">#Oorigen#</a></strong>
		<cfif rsReporte.MActivo EQ 1>
			Cuenta de mayor definida por el Valor
        </cfif>
		<center>
		<table width="80%" cellpadding="2" cellspacing="10">
			<tr>
				<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="33%">
					Valor
				</td>
				<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="33%">
					Cuenta de Mayor
				</td>
				<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="33%">
					Complemento
				</td>

			</tr>
		</table>
		</center>
		<cfoutput>
			<center>
			<table width="80%" cellpadding="2" cellspacing="10">
				<tr>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="33%">
						#ODchar#
					</td>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="33%">
						#Cmayor#
					</td>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="33%">
						<cfif ODcomplemento EQ "" or len(trim(ODcomplemento)) EQ 0>
						Complemento Vacio
						<cfelse>
						#ODcomplemento#
						</cfif>
					</td>
				</tr>
			</table>
			</center>
		</cfoutput>		
	</cfoutput>
<cf_web_portlet_end>
<cfelseif isdefined("url.Externos")>
<cfif not isdefined("url.SE")>
<cf_templateheader title="Consulta Origenes">
</cfif>
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Catalogos Externos'>
		<cfoutput>
			<form id="form1" name="form1" method="post" action="ConsultaOrigen.cfm?Externos">
				<table class="AreaFiltro" width="100%">
					<tr>
						<td align="center" colspan="4">
							<strong> FILTROS DE LA CONSULTA </strong>
						</td>
					</tr>
					<tr>
						<td align="left" width="10%">
							<input type="button" value="Inicio" onclick=javascript:document.form1.action="ConsultaOrigen.cfm";submit() />
						</td>
						<cfif not isdefined("url.Origen")>
							<td width="20%">
								<input type="checkbox" name="OpcionD" onclick="submit()" <cfif isdefined("form.OpcionD") and form.OpcionD EQ "on">checked="checked"</cfif>/> Solo Cat&aacute;logos Externos
							</td>
							<td width="35%">
								<input type="checkbox" name="OpcionE" onclick="submit()" <cfif isdefined("form.OpcionE") and form.OpcionE EQ "on">checked="checked"</cfif>/> Cat&aacute;logos configurados (En esta empresa)
							</td>
							<td width="35%">
								<input type="checkbox" name="OpcionF" onclick="submit()" <cfif isdefined("form.OpcionF") and form.OpcionF EQ "on">checked="checked"</cfif>/> Cat&aacute;logos que apliquen a esta empresa
							</td>
						</cfif>
					</tr>
				</table>
			</form>
		</cfoutput>
		<cfquery name="rsReporte" datasource="sifcontrol">
			select t.*
			from OrigenTablaProv t
			inner join OrigenProv o
				<cfif isdefined("form.OpcionF") and form.OpcionF EQ "on">
				inner join #session.DSN#..ConceptoContable cc
				on o.Oorigen = cc.Oorigen and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfif>
				<cfif isdefined("form.OpcionE") and form.OpcionE EQ "on">
				inner join #session.DSN#..OrigenDatos od
				on o.Oorigen = od.Oorigen and od.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and o.OPtabla = od.OPtabla
				</cfif>
			on t.OPtabla = o.OPtabla
			<cfif isdefined("form.OpcionD") and OpcionD EQ "on">
			where t.OPcatalogoPlan = 1
			</cfif>
			order by t.OPtabla
		</cfquery>
		<center>
		<strong>Catalogos Externos</strong>
		<table width="80%" cellpadding="2" cellspacing="10">
			<tr>
				<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
					<strong>Catalogo</strong>
				</td>
				<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
					<strong>Tipo</strong>
				</td>
			</tr>
		</table>
		</center>
		<cfoutput query="rsReporte" group="OPtabla">
			<center>
			<table width="80%" cellpadding="2" cellspacing="10">
				<tr>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
						<a href="ConsultaOrigen.cfm?Tabla=#Optabla#&Todo&TipoT=#OPcatalogoPlan#" target="_blank">#OPtabla#</a>
					</td>
					<td bgcolor="CCCCCC" bordercolor="000000" align="center" width="30%">
						<cfif OPcatalogoPlan EQ 0>
						Cat&aacute;logo Interno de SIF
						<cfelse>
						Cat&aacute;logo Externo
						</cfif>
					</td>
				</tr>
			</table>
			</center>
	</cfoutput>
	<cf_web_portlet_end>
<cfif not isdefined("url.SE")>
<cf_templatefooter>
</cfif>
</cfif>