<cftransaction>
	<cfinvoke 
	 component="sif.Componentes.PRES_Presupuesto"
	 method="sbAjustaNrpAprobar">
		<cfinvokeargument name="NRP" value="#Form.CPNRPnum#"/>
		<cfinvokeargument name="Conexion" value="#session.dsn#"/>
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
	</cfinvoke>

	<cfquery name="rsLista" datasource="#Session.DSN#">
		select	<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.DSN#">
				#_Cat#'-'#_Cat#
				case a.CPCmes 
					when 1 then 'ENE' 
					when 2 then 'FEB' 
					when 3 then 'MAR' 
					when 4 then 'ABR' 
					when 5 then 'MAY' 
					when 6 then 'JUN' 
					when 7 then 'JUL' 
					when 8 then 'AGO' 
					when 9 then 'SET' 
					when 10 then 'OCT' 
					when 11 then 'NOV' 
					when 12 then 'DIC' 
					else '' 
				end as MesDescripcion,
				o.Oficodigo,
				b.CPformato as CuentaPresupuesto,
				(sum(a.CPNRPDsigno*a.CPNRPDmonto)) as TotalMovimiento,
				(min(coalesce(a.CPNRPDdisponibleAntes,0) + a.CPNRPDsigno*a.CPNRPDmonto)) as DisponibleRechazo,
				(min(coalesce(a.CPNRPDdisponibleAntesAprobar,0)+a.CPNRPDsigno*a.CPNRPDmonto)) as DisponibleAprobar,
				case 
					when min(coalesce(a.CPNRPDdisponibleAntesAprobar,0)+a.CPNRPDsigno*a.CPNRPDmonto) < sum(a.CPNRPDsigno*a.CPNRPDmonto) then
						-min(coalesce(a.CPNRPDdisponibleAntesAprobar,0)+a.CPNRPDsigno*a.CPNRPDmonto)
					else
						-sum(a.CPNRPDsigno*a.CPNRPDmonto)
				end as TotalExceso
		from 	CPNRPdetalle a
					left join CPresupuesto b
						 on b.CPcuenta = a.CPcuenta
						and b.Ecodigo  = a.Ecodigo
					left join Oficinas o
						 on o.Ecodigo = a.Ecodigo
						and o.Ocodigo = a.Ocodigo
		where	a.Ecodigo = #Session.Ecodigo# 
		  and 	a.CPNRPnum = #Form.CPNRPnum#
		<cfif LvarExcesoConTraslado>
		  and 	a.CPCPtipoControl in (1,2)
		<cfelse>
		  and 	a.CPCPtipoControl = 1
		</cfif>
		  and (
				select count(1)
				  from CPNRPdetalle
				 where Ecodigo	= a.Ecodigo
				   and CPNRPnum = a.CPNRPnum
				   and CPCano	= a.CPCano
				   and CPCmes	= a.CPCmes
				   and CPcuenta	= a.CPcuenta
				   and Ocodigo	= a.Ocodigo
				   and CPNRPDconExceso = 1
			  ) > 0
		group 	by a.CPCano, a.CPCmes, b.CPformato, o.Oficodigo
	</cfquery>
	<cftransaction action="rollback" />
</cftransaction>

<cfif rsLista.recordcount GT 0>
	<tr>
		<td align="center" style="padding-left: 10px; padding-right: 10px;">
			<cfif LvarExcesoConTraslado>
				<cfset LvarTipoAutorizado = "Traslado">
				<cf_web_portlet_start titulo="Destinos del #LvarTipoAutorizado# a Autorizar por Excesos Generados">
			<cfelse>									
				<cfset LvarTipoAutorizado = "Exceso">
				<cf_web_portlet_start titulo="Detalle de #LvarTipoAutorizado#s a Autorizar">
			</cfif>
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="MesDescripcion, CuentaPresupuesto, Oficodigo, TotalMovimiento, DisponibleRechazo, DisponibleAprobar, TotalExceso"/>
					<cfinvokeargument name="etiquetas" value="Mes, Cuenta<br>Presupuesto, Oficina, Total Movs.<br>Rechazados,Disponible Gen.<br>en Rechazo,Disponible Gen.<br>en Aprobación,#LvarTipoAutorizado# Max.<br>a Autorizar"/>
					<cfinvokeargument name="formatos" value="V,V,V,M,M,M,M"/>
					<cfinvokeargument name="align" value="center, left, left, right,right, right, right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="formName" value="listaNRPS"/>
					<cfinvokeargument name="MaxRows" value="0"/>
					<cfinvokeargument name="PageIndex" value="10"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="lineaRoja" value="DisponibleAprobar LT 0"/>
			</cfinvoke>
			<cf_web_portlet_end>
		</td>
	<tr>
		<td align="right">
			<cfoutput>
			Maximo #LvarTipoAutorizado# total a autorizar: 
			</cfoutput>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<cfoutput><strong>#numberFormat(rsExceso.total,",0.00")#</strong></cfoutput>
			&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
	</tr>
	<tr>
		<td class="style1">
			<cfoutput>
			&nbsp;&nbsp;&nbsp;(*) Se generará un #LvarTipoAutorizado# Autorizado con el monto de cada Exceso Generado en el momento de la Aplicación, como máximo el indicado<BR>
			</cfoutput>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Max a Autorizar = menor monto negativo entre el Disponible Real Generado y el Total de Movimientos del Documento)<BR>
		</td>
	</tr>
</cfif>
