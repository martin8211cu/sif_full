<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Ocupaci&oacute;n de plaza</title>
</head>
<body>

<cf_templatecss> 
<cfset form.DEid = 0 >

<cfif isdefined("url.RHSAid") and len(trim(url.RHSAid))>
	<cfquery name="rsSituacionA" datasource="#session.DSN#">
		select RHEid, RHPPid, RHMPPid, RHCid, RHTTid, fdesdeplaza, fhastaplaza
		from RHSituacionActual
		where RHSAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHSAid#">
			and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif isdefined("rsSituacionA") and rsSituacionA.RecordCount NEQ 0> 		
		
		<cfquery name="rsOcupaPlaza" datasource="#session.DSN#">
			select distinct f.DEidentificacion, t.RHPid, a.RHEid,a.RHPPid,
				a.RHPEid,
				convert(varchar,a.RHPEfinicioplaza,103) as RHPEfinicioplaza,
				case a.RHPEffinplaza 	when '61000101' then 'Indefinidos'
										else convert(varchar,a.RHPEffinplaza,103)
				end as RHPEffinplaza,
				
				ltrim(rtrim(z.RHPPcodigo))+' - '+ltrim(rtrim(z.RHPPdescripcion)) as PlazaPresupuestaria
				,ltrim(rtrim(t.RHPcodigo))+' - '+ltrim(rtrim(t.RHPdescripcion)) as PlazaRH
				<!---,ltrim(rtrim(f.DEnombre)) + ' ' +ltrim(rtrim(f.DEapellido1)) + ' ' + ltrim(rtrim(f.DEapellido2)) as Empleado--->
                ,ltrim(rtrim(f.DEapellido1)) + ' ' + ltrim(rtrim(f.DEapellido2)) + ' ' +ltrim(rtrim(f.DEnombre)) as Empleado
				,ltrim(rtrim(b.RHPcodigo))+' - '+ltrim(rtrim(b.RHPdescpuesto)) as PuestoRH
				,f.DEid, 
				coalesce((select LTporcplaza
				from LineaTiempo l
				where a.DEid = l.DEid and  t.RHPid = l.RHPid and l.LThasta = a.RHPEffinplaza  )
				,
				 (select LTporcplaza
				from LineaTiempoR r
				where a.DEid = r.DEid and  t.RHPid = r.RHPid and  r.LThasta = a.RHPEffinplaza )
				) as LTporcplaza
				,z.RHPPcodigo, z.RHPPdescripcion
				,b.RHPcodigo, b.RHPdescpuesto
			from RHPlazasEscenario a						
			inner join RHPlazaPresupuestaria z
				on a.RHPPid = z.RHPPid
			
				inner join RHPlazas t
					on z.RHPPid = t.RHPPid
					and t.RHPactiva = 1
			
				inner join RHPuestos b
					on t.RHPpuesto = b.RHPcodigo
					and t.Ecodigo = b.Ecodigo
			
				inner join RHLineaTiempoPlaza g
					on a.RHPPid = g.RHPPid
					and g.RHMPestadoplaza = 'A'
                    and a.RHPEfinicioplaza <= g.RHLTPfhasta and a.RHPEffinplaza >= g.RHLTPfdesde
					
				inner join DatosEmpleado f
					on a.DEid = f.DEid

				where a.Ecodigo = #session.Ecodigo#
					and a.RHEid = #rsSituacionA.RHEid#
					and a.RHPPid is not null
					and a.RHPPid = #rsSituacionA.RHPPid#
					
				order by a.RHPEfinicioplaza, ltrim(rtrim(f.DEapellido1)) + ' ' + ltrim(rtrim(f.DEapellido2)) + ' ' +ltrim(rtrim(f.DEnombre)) 
		</cfquery>
		<cfif len(trim(rsOcupaPlaza.DEid)) >
			<cfset form.DEid = rsOcupaPlaza.DEid >
		</cfif> 
	</cfif> 
</cfif>
<cfoutput>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificacion"
	returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	Default="Desde"
	returnvariable="LB_Desde"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta"
	returnvariable="LB_Hasta"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PorcentajeOcupacion"
	Default="% Ocupacion"
	returnvariable="LB_PorcentajeOcupacion"/>	
	
	
<table width="100%" cellpadding="1" cellspacing="0" align="center" border="0">
	<tr>
		<td colspan="4" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Ocupaci&oacute;n de Plaza</strong></td>
	</tr>
	<tr>
		<td colspan="4" align="center">
			<table width="95%" align="center" border="0">
				<tr>
					<td><hr/></td>
				</tr>	
			</table>
		</td>
	</tr>
	<cfif isdefined("rsOcupaPlaza") and rsOcupaPlaza.RecordCount NEQ 0>
		<tr>
			<!---<td align="right" nowrap="nowrap"><strong>C&oacute;digo Presupuestario:&nbsp;</strong></td>--->
			<td align="center"><strong>#rsOcupaPlaza.RHPPcodigo# - #rsOcupaPlaza.RHPPdescripcion#</strong></td>
			<!---<td align="right" nowrap="nowrap"><strong>Codigo Puesto:&nbsp;</strong></td>--->
			<td align="center"><strong>#rsOcupaPlaza.RHPcodigo# - #rsOcupaPlaza.RHPdescpuesto#</strong></td>
		</tr>
		<tr><td colspan="4">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr><td colspan="4" align="center">	
					<cfinvoke Component= "rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaOcuapa">
						<cfinvokeargument name="query" value="#rsOcupaPlaza#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion, Empleado, RHPEfinicioplaza, RHPEffinplaza,LTporcplaza"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#,#LB_Desde#,#LB_Hasta#,#LB_PorcentajeOcupacion#"/>
						<cfinvokeargument name="formatos" value="V,V,V,V,V"/>
						<cfinvokeargument name="align" value="left,left,Center,Center,Center"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="showLink" value="false"/>
						<cfinvokeargument name="maxrows" value="25"/> 	
					</cfinvoke>
			</td></tr>						
			</table>
		<td></tr>
	<cfelse>
		<tr><td colspan="4" align="center"><strong>---  No hay nung&uacute;n empleado asignado a la plaza ---</strong></td></tr>
	</cfif>
		<tr><td colspan="4" align="center"><input type="button" name="btn_cerrar" value="Cerrar" onclick="javascript: window.close();"/></td></tr>
	</table>	
	
</cfoutput>
</body>
</html>
