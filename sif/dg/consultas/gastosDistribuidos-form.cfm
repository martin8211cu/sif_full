<cfif isdefined("url.DGGDid") and not isdefined("form.DGGDid") >
	<cfset form.DGGDid = url.DGGDid >
</cfif>

<cfif isdefined("url.periodo") and not isdefined("form.periodo") >
	<cfset form.periodo = url.periodo >
</cfif>

<cfif isdefined("url.mes") and not isdefined("form.mes") >
	<cfset form.mes = url.mes >
</cfif>

<cfif isdefined("url.orden") and not isdefined("form.orden") >
	<cfset form.orden = url.orden >
</cfif>

<cfif isdefined('form.orden')>
	<cfset LvarOrden = form.orden>
<cfelse>
	<cfset LvarOrden = 'C'>
</cfif>

<cfif isdefined("url.proceso") and isdefined("url.btnBorrar") and btnBorrar eq 'ok' and isdefined("url.id") and len(trim(url.id))>
<!--- 	
	<cfquery datasource="#session.DSN#">
		delete from DGGastosxDistribuir
		where DGDGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
	</cfquery>
 --->
	<cfquery datasource="#session.DSN#">
		update DGGastosxDistribuir
		set 
			 Debitos = 0,
			 Creditos = 0,
			 montodist = 0,
			 Presupuesto = 0
		where DGDGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
	</cfquery>

</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select 	a.DGGDid,
			a.DGGDcodigo,
			a.DGGDdescripcion, 
			( select rtrim(DGCcodigo) #_Cat#' - ' #_Cat# DGdescripcion
			  from DGConceptosER
			  where DGCid = a.DGCiddest ) as destino, 
			DGCDid,
			( select rtrim(DGCDcodigo) #_Cat#' - ' #_Cat# DGCDdescripcion
			  from DGCriteriosDistribucion
			  where DGCDid = a.DGCDid ) as criterio, 
			DGCid,
			( select rtrim(DGCcodigo) #_Cat#' - ' #_Cat# DGdescripcion
			  from DGConceptosER
			  where DGCid = a.DGCid ) as concepto, 
			
			case Criterio when 30 then 'Presupuesto Acumulado' 
						  when 40 then 'Real Acumulado'
						  when 50 then 'Presupuesto Mes'
						  when 60 then 'Real Mes'
			end as Criterio
	from DGGastosDistribuir a
	where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" >
	order by a.DGGDcodigo
</cfquery>

<cfquery name="rsPorDistribuir" datasource="#session.DSN#">
	select 	a.DGDGid,
			a.DGGDid, 
			a.DGCDid, 
			a.Departamento, 
			depto.PCDvalor, 
			depto.PCDdescripcion, 
			a.Ocodigo, 
			o.Oficodigo as Odescripcion,
			a.Empresa,
			e.Edescripcion, 
			a.montodist,
			a.Presupuesto,
			cc.Cformato 
	from DGGastosxDistribuir a
	
	inner join PCDCatalogo depto
	on depto.PCDcatid=a.Departamento
	
	inner join Oficinas o
	on o.Ecodigo=a.Empresa
	and o.Ocodigo=a.Ocodigo
	
	inner join Empresas e
	on e.Ecodigo=a.Empresa
	
	inner join CContables cc
	on cc.Ccuenta=a.Ccuenta
	
	where a.DGGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" >
	  and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	  and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	
	<cfif LvarOrden eq 'D'>
		order by e.Edescripcion, depto.PCDvalor, o.Oficodigo
	<cfelse>
		order by e.Edescripcion, cc.Cformato, depto.PCDvalor, o.Oficodigo
	</cfif>	


</cfquery>

<cfquery name="rsDistribuido" datasource="#session.DSN#">
	select a.DGGDid,
		a.Departamento, 
		depto.PCDvalor, 
		depto.PCDdescripcion, 
		o.Oficodigo as Odescripcion,
		a.Empresa,
		e.Edescripcion,
		a.Ocodigo, 
		a.valorcriterio, 
		a.montoasignado,
		a.presasignado

	from DGGastosDistribuidos a

		inner join PCDCatalogo depto
		on depto.PCDcatid=a.Departamento
	
		inner join Oficinas o
		on o.Ecodigo=a.Empresa
		and o.Ocodigo=a.Ocodigo
	
		inner join Empresas e
		on e.Ecodigo=a.Empresa

	where a.DGGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGGDid#" >
	  and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	  and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	order by e.Edescripcion, depto.PCDvalor, o.Oficodigo	  
</cfquery>

<cf_templatecss>

<cfoutput>
<cfset listaMes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>

<table width="100%" cellpadding="0" cellspacing="0" align="center">
	<cfif isdefined("url.proceso")>
	<tr><td align="right"><input type="button" name="Regresar" value="Regresar" class="btnAnterior" onclick="javascript:location.href = '/cfmx/sif/dg/operacion/gastosDistribuir-verificacion.cfm?periodo=#form.periodo#&mes=#form.mes#';" /></td></tr>	
	</cfif>
	<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Consulta de Gastos Distribuidos</strong></td></tr>
	<tr><td align="center"><strong>Per&iacute;odo:</strong> #form.periodo#</td></tr>
	<tr><td align="center"><strong>Mes:</strong> #listgetat(listaMes, form.mes)#</td></tr>
	
</table>
<br>
</cfoutput>

<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	<cfoutput>
	<tr>
		<td bgcolor="##e5e5e5" colspan="3">
			<table width="98%" align="center" cellpadding="2" cellspacing="0">
				<tr style="padding:2px">
					<td width="1%" nowrap="nowrap" style="padding:2px"><strong>Gasto a Distribuir:</strong></td>
					<td style="padding:2px">#trim(data.DGGDcodigo)# - #data.DGGDdescripcion#</td>
				</tr>
				<cfif len(trim(data.DGCid))>
					<tr style="padding:4px">
						<td width="1%" nowrap="nowrap" style="padding:4px"><strong>Concepto ER:</strong></td>
						<td style="padding:4px">#data.concepto#</td>
					</tr>
					<tr style="padding:4px">
						<td width="1%" nowrap="nowrap" style="padding:4px"><strong>Criterio:</strong></td>
						<td style="padding:4px">#data.Criterio#</td>
					</tr>
				<cfelse>
				<tr style="padding:2px">
						<td width="1%" nowrap="nowrap" style="padding:4px"><strong>Criterio de Distribuci&oacute;n:</strong></td>
						<td style="padding:4px">#data.criterio#</td>
					</tr>
				</cfif>
				<tr style="padding:2px">
					<td width="1%" style="padding:4px" nowrap="nowrap"><strong>Concepto ER destino:</strong></td>
					<td style="padding:4px">#data.destino#</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfoutput>
	<tr><td>&nbsp;</td></tr>
	<tr >
		<td style="padding:4px;" bgcolor="#e5e5e5">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="3"><strong>Gastos por Distribuir</strong></td>
				</tr>			
				<cfif not isdefined("url.imprimir")>
				<tr >
					<td width="1%" nowrap="nowrap"><strong>Ordenar por:</strong></td>
					<td align="center" width="40%" nowrap="nowrap"><input type="radio" name="orden" value="D" <cfif LvarOrden eq 'D'>checked</cfif> onclick="javascript:ordenar(this.value)"/>Departamento</td>
					<td align="center" width="40%" nowrap="nowrap"><input type="radio" name="orden" value="C" <cfif LvarOrden eq 'C'>checked</cfif> onclick="javascript:ordenar(this.value)"/>Cuenta</td>
				</tr>			
				</cfif>
			</table>
		

		<td>&nbsp;</td>
		<td style="padding:4px;" bgcolor="#e5e5e5"><strong>Gastos Distribuidos</strong></td>
	</tr>
	<tr>
		<td width="50%" valign="top">
			<table width="100%" cellpadding="2" cellspacing="0">
				<cfoutput query="rsPorDistribuir" group="Edescripcion">
					<tr><td colspan="7" valign="top" class="listaCorte" style="border-bottom: 1px solid gray;">Empresa: #trim(rsPorDistribuir.Edescripcion)#</td></tr>
					<tr>

						<cfif LvarOrden eq 'D'>
							<td class="tituloListas">Depto</td>
							<td class="tituloListas">Oficina</td>
							<td class="tituloListas">Cuenta</td>
						<cfelse>
							<td class="tituloListas">Cuenta</td>
							<td class="tituloListas">Depto</td>
							<td class="tituloListas">Oficina</td>
						</cfif>
						<td class="tituloListas" align="right">Monto</td>						
						<td class="tituloListas" align="right">Presupuesto</td>						

						<cfif isdefined("url.proceso")>
							<td valign="top" class="tituloListas" align="right">&nbsp;</td>
							<td valign="top" class="tituloListas" align="right">&nbsp;</td>							
						</cfif>

					</tr>
					<CFOUTPUT>
					<tr>
						<cfif LvarOrden eq 'D'>
							<td valign="top">#trim(rsPorDistribuir.PCDvalor)#</td>
							<td valign="top">#trim(rsPorDistribuir.Odescripcion)#</td>
							<td valign="top">#trim(rsPorDistribuir.Cformato)#</td>
						<cfelse>
							<td valign="top">#trim(rsPorDistribuir.Cformato)#</td>
							<td valign="top">#trim(rsPorDistribuir.PCDvalor)#</td>
							<td valign="top">#trim(rsPorDistribuir.Odescripcion)#</td>
						</cfif>
							<td valign="top" align="right">#LSNumberFormat(rsPorDistribuir.montodist, ',9.00')#</td>
							<td valign="top" align="right">#LSNumberFormat(rsPorDistribuir.Presupuesto, ',9.00')#</td>

						<cfif isdefined("url.proceso")>
							<td valign="top" align="right"><img src="../../imagenes/Borrar01_S.gif" style="cursor:pointer;" title="Eliminar este registro" onclick="javascript:eliminar('#rsPorDistribuir.DGDGid#', '#LvarOrden#');" /></td>
							<td valign="top" align="right"><img src="../../imagenes/iedit.gif" style="cursor:pointer;" title="Modificar montos" onclick="javascript:modificar('#rsPorDistribuir.DGDGid#','#form.DGGDid#','#form.periodo#','#form.mes#', '#form.orden#');" /></td>
						</cfif>
					</tr>
					</CFOUTPUT>
				</cfoutput>					
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="50%" valign="top">
			<table width="100%" cellpadding="2" cellspacing="0">
				<cfoutput query="rsDistribuido" group="Edescripcion">
					<tr><td colspan="5" valign="top" class="listaCorte" style="border-bottom: 1px solid gray;">Empresa: #trim(rsDistribuido.Edescripcion)#</td></tr>
					<tr>
						<td class="tituloListas">Depto</td>
						<td class="tituloListas">Oficina</td>
						<td class="tituloListas" align="right">Peso</td>
						<td class="tituloListas" align="right">Distribuido</td>
						<td class="tituloListas" align="right">Presupuesto</td>
					</tr>
					<CFOUTPUT>
						<tr>
							<td valign="top">#trim(rsDistribuido.PCDvalor)#</td>
							<td valign="top">#trim(rsDistribuido.Odescripcion)#</td>
							<td valign="top" align="right">#LSNumberFormat(rsDistribuido.valorcriterio, ',9.00')#</td>					
							<td align="right">#LSNumberFormat(rsDistribuido.montoasignado, ',9.00')#</td>
							<td align="right">#LSNumberFormat(rsDistribuido.presasignado, ',9.00')#</td>
						</tr>
					</CFOUTPUT>
				</cfoutput>
			</table>
		</td>
	</tr>

	<tr><td>&nbsp;</td></tr>	
	<tr><td colspan="3" align="center">--- Fin del reporte ---</td></tr>	
	<tr><td>&nbsp;</td></tr>	
	<cfif isdefined("url.proceso")>
	<cfoutput>
	<tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" class="btnAnterior" onclick="javascript:location.href = '/cfmx/sif/dg/operacion/gastosDistribuir-verificacion.cfm?periodo=#form.periodo#&mes=#form.mes#';" /></td></tr>	
	<tr><td>&nbsp;</td></tr>	
	</cfoutput>	
	</cfif>
</table>

<!--- <cfif isdefined("url.proceso")> --->
	<CFOUTPUT>
	<form method="get" name="form1" style="margin:0" action="gastosDistribuidos.cfm">
		<input type="hidden" name="DGGDid" value="#form.DGGDid#" />
		<input type="hidden" name="periodo" value="#form.periodo#" />
		<input type="hidden" name="mes" value="#form.mes#" />
		<input type="hidden" name="orden" value="D" />
		<cfif isdefined("url.proceso")>
			<input type="hidden" name="proceso" value="ok" />
			<input type="hidden" name="id" value="" />
			<input type="hidden" name="btnBorrar" value="ok" />
		</cfif>
	</form>
	</CFOUTPUT>

	<script language="javascript1.2" type="text/javascript">
		popUpWin = 0;

		function eliminar(id, valor){
			if (confirm('Desea eliminar el registro?')){
				document.form1.orden.value = valor;
				document.form1.id.value = id;
				document.form1.submit();
			}
		}
		
		function modificar(id,grupo,periodo,mes,orden){
			closePopup();
			popUpWin = window.open('gastosDistribuidos-modificar.cfm?DGDGid='+id+'&DGGDid='+grupo+'&periodo='+periodo+'&mes='+mes+'&orden='+orden,'_blank',
				'left=250,top=200,width=700,height=400,status=no,toolbar=no,title=no');
			window.onfocus = closePopup;
		}
		
		function closePopup() {
			/*if (popUpWin && !popUpWin.closed ) {
				popUpWin.close();
				popUpWin = null;
			}
			*/
		}
		
		function ordenar(valor){
			document.form1.orden.value = valor;
			document.form1.submit();
		}
	</script>

<!--- </cfif> --->