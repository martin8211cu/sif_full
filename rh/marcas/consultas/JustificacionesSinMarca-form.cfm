<!--- valida de la fecha desde sea menor a la fecha superior --->
<cfif isdefined("url.fdesde") and  isdefined("url.fhasta") and len(trim(url.fdesde)) neq 0 and len(trim(url.fhasta)) neq 0> 
	<cfif url.fdesde GT url.fhasta>
		<cfset temp = url.fhasta>
		<cfset url.fhasta = url.fdesde>
		<cfset url.fdesde = temp>
	</cfif>
</cfif>

<!----=============== TRADUCCION ===============---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Omision_de_Marca_de_Entrada"
	Default="Omisión de Marca de Entrada"	
	returnvariable="LB_Omision_de_Marca_de_Entrada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Omision_de_Marca_de_Salida"
	Default="Omisión de Marca de Salida"	
	returnvariable="LB_Omision_de_Marca_de_Salida"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dia_Extra"
	Default="Día Extra"	
	returnvariable="LB_Dia_Extra"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dia_Libre"
	Default="Día Libre"	
	returnvariable="LB_Dia_Libre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Llegada_Anticipada"
	Default="Llegada Anticipada"	
	returnvariable="LB_Llegada_Anticipada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Llegada_Tarde"
	Default="Llegada Tarde"	
	returnvariable="LB_Llegada_Tarde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Salida_Anticipada"
	Default="Salida Anticipada"	
	returnvariable="LB_Salida_Anticipada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Salida_Tarde"
	Default="Salida Tarde"	
	returnvariable="LB_Salida_Tarde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_hay_Justificacion"
	Default="No hay Justificación"	
	returnvariable="LB_No_hay_Justificacion"/>

<cfquery name="datos" datasource="#session.DSN#" >
	select distinct
			i.RHJMUid,
			{fn concat(e.DEidentificacion,{fn concat('-',{fn concat(e.DEnombre,{fn concat(e.DEapellido1,{fn concat(' ',e.DEapellido2)})})})})} as Empleado,
			{fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat('-',cf.CFdescripcion)})} as centroFuncional,	
			case  i.RHJMUsituacion
				when 0 then '#LB_Omision_de_Marca_de_Entrada#'
				when 1 then '#LB_Omision_de_Marca_de_Salida#'
				when 2 then '#LB_Dia_Extra#'
				when 3 then '#LB_Dia_Libre#'
				when 4 then '#LB_Llegada_Anticipada#'
				when 5 then '#LB_Llegada_Tarde#'
				when 6 then '#LB_Salida_Anticipada#'
				when 7 then '#LB_Salida_Tarde#'
			end as tipoInconsistencia,	
			i.RHJMUfecha as fecha,		
			case when ltrim(rtrim(i.RHJMUjustificacion)) is null then 
				'#LB_No_hay_Justificacion#'
			else 
				i.RHJMUjustificacion 
			end as justificacion	
	from
		RHJustificacionMarcasUsuario i
		
		inner join DatosEmpleado e
			on e.DEid = i.DEid
			and e.Ecodigo = i.Ecodigo
		
		inner join LineaTiempo b
			on b.DEid = e.DEid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.LTdesde and b.LThasta
		inner join RHPlazas c
			on c.RHPid = b.RHPid
	
		inner join CFuncional cf
			on cf.CFid = c.CFid
			and cf.Ecodigo = i.Ecodigo
	where i.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
		<cfif isdefined("url.DEid") and len(trim(url.DEid))neq 0>
			and i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>		
		<cfif isdefined("url.CFid") and len(trim(url.CFid))neq 0>
			and c.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		</cfif>		
		and i.RHJMUprocesada=0	 
		and i.RHJMUfecha >= <cfqueryparam cfsqltype="timestamp" value="#LSDateFormat(url.fdesde,'mm/dd/yyyy')#"/>
		and i.RHJMUfecha <= <cfqueryparam cfsqltype="timestamp" value="#LSDateFormat(url.fhasta,'mm/dd/yyyy')#"/>
		
	order by cf.CFcodigo,e.DEidentificacion,i.RHJMUfecha
</cfquery>

<cfif datos.recordcount gt 0 >
	<cfreport format="#url.formato#" template="JustificacionesSinMarca.cfr" query="datos">
		<cfreportparam name="empresa" value="#session.Enombre#">
		<cfreportparam name="fdesde" value="#url.fdesde#">
		<cfreportparam name="fhasta" value="#url.fhasta#">
	</cfreport>
<cfelse>
	<cfdocument format="flashpaper" marginleft="0" marginright="0" marginbottom="0" margintop="0" unit="in">
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" style="margin:0; " >
		<tr>
			<td>
				<table width="100%" cellpadding="3px" cellspacing="0">
					<tr bgcolor="##E3EDEF" style="padding-left:100px; "><td width="2%">&nbsp;</td><td><font size="1" color="##6188A5">#session.Enombre#</font></td></tr>
					<tr bgcolor="##E3EDEF"><td width="2%">&nbsp;</td><td ><font size="+1"><cf_translate key="LB_Justificaciones_sin_marca_relacionada">Justificaciones sin Marca Relacionada</cf_translate></font></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style=" font-family:Helvetica; font-size:8; padding:8px;" align="center">-- <cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate> --</td>
		</tr>
	</table>
	</cfoutput>
	</cfdocument>
</cfif>