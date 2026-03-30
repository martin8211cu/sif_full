<!-----
	a.	Cedula(9)
b.	 Planilla(1)
c.	Centro Funcional(4)
d.	Estado(1)
e.	Nombre(40)
f.	Salario son determinar(16)
g.	Sexo(1)
h.	Fecha de nacimiento(8)  ddmmyyyy
i.	Fecha de ingreso al ICE(8)  ddmmyyyy
j.	Embargo(1)   0 – no embargado, 1 – embargado
k.	Sin determinar(3)
l.	patrono (18) 
m.	puesto (5)
n.	correo electrónico
 ------->



<!---- validaciones de la configuración de las columnas----->
<cfquery datasource="#session.dsn#" name="rsValida">
	select x.cod as cod
	from
	(
	   select 'EMB' as cod from dual
	) x
	where x.cod not in ( select RHCRPTcodigo 
	                    from RHReportesNomina a 
	                    inner join RHColumnasReporte b
	                        on a.RHRPTNid=b.RHRPTNid
	                    inner join RHConceptosColumna c
	                    	on b.RHCRPTid=c.RHCRPTid
	                    where a.Ecodigo=#session.Ecodigo#
	                    and rtrim(ltrim(RHRPTNcodigo)) = 'CERT' 
	                    )
</cfquery>
<cfif len(trim(rsValida.cod))>
	<cf_errorCode code="52229" msg="Configuración requerida. Es necesario configurar las columnas para el reporte: '@codReporte@'"
		codReporte='Certificaciones RH'
		detail="Reporte 'CERT': Lista de columnas: #valuelist(rsValida.cod,', ')#"
	> 	
</cfif>
   

<cf_dbfunction name="op_concat" returnvariable="concat">

<cfset p=''>
<cfset RCNid=0>
<cfset Tcodigo=''>


<!----- Seteo de filtros----->
<cfif isDefined("form.tiponomina")>
	<cfset p='H'>
</cfif>
<cfif isDefined("form.tiponomina") and isDefined("form.CPid1") and len(trim(form.CPid1))>
	<cfset RCNid=form.CPid1>
</cfif>
<cfif isDefined("form.CPid2") and len(trim(form.CPid2))>
	<cfset RCNid=form.CPid2>
</cfif>
 
<cfquery datasource="#session.dsn#" name="rsReporte">
	select a.DEidentificacion as Cedula,1 as Planilla,6020 as Centro_Funcional,1,DEnombre#concat#' '#concat#DEapellido1#concat#' ' #concat#DEapellido2 as nombre_completo, '0000000000000000' as SalariosSinDeterminar,DEsexo,
	DEfechanac as Fecha_Nacimiento,
	CASE DEcivil
				  WHEN 0 THEN 6
				  WHEN 1 THEN 1
				  WHEN 2 THEN 2
				  WHEN 3 THEN 8
				  WHEN 4 THEN 7
			END AS Estado_civil, 
	EVfantig as Fecha_Ingreso,

	case when (
			select count(1)
		    from RHReportesNomina nn 
		    inner join RHColumnasReporte nc
		        on nn.RHRPTNid=nc.RHRPTNid
		        and rtrim(ltrim(nn.RHRPTNcodigo)) = 'CERT'
		        and upper(rtrim(ltrim(nc.RHCRPTcodigo))) = 'EMB'
		    inner join RHConceptosColumna cc
		    	on nc.RHCRPTid=cc.RHCRPTid
		    	and cc.TDid is not null 
		    inner join DeduccionesEmpleado dd
		    	on cc.TDid = dd.TDid	
		    inner join #p#DeduccionesCalculo de
		    	on de.Did=dd.Did
		    	and de.RCNid = #RCNid#
		    where nn.Ecodigo=#session.Ecodigo#	
		    	and de.DEid=a.DEid	    
	    ) > 0 then 1 
		else 0 end as Embargo

	,'TEL' as Sin_Determinar, '000000000000000000' as Patrono, RHPcodigo, DEemail
 
	from DatosEmpleado a
		inner join #p#SalarioEmpleado b
			on a.DEid = b.DEid
		inner join CalendarioPagos cp
			on b.RCNid=cp.CPid	
		inner join EVacacionesEmpleado c
			on b.DEid = c.DEid
		inner join LineaTiempo z
			on a.DEid = z.DEid
	where b.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" list="true">)
		and z.LThasta = (
							select max(xx.LThasta)
							from LineaTiempo xx
							where a.DEid=xx.DEid
							and xx.LTdesde <= cp.CPhasta
							and xx.LThasta > =cp.CPdesde
						)
	order by a.DEidentificacion
</cfquery>

<cfif !len(trim(rsReporte.Cedula))>
	<cf_errorCode code="52228" msg="No existen registros para mostrar">
</cfif>

<cffunction name="limitar">
	<cfargument name="texto" type="string">
	<cfargument name="tam" type="string">

	<cfif arguments.tam lte len(trim(arguments.texto))>
		<cfreturn mid(arguments.texto,1,arguments.tam)>
	<cfelse>		
		<cfreturn mid(arguments.texto,1,arguments.tam) & repeatString(" ", arguments.tam-len(trim(arguments.texto)) )>
	</cfif>
</cffunction>

<cfset salida=''>
<cfloop query="rsReporte">
	<cfset salida&=limitar(trim(cedula),9)&'160201'&limitar(trim(nombre_completo),40)&'0000000000000000'&DEsexo&LSDateformat(Fecha_Nacimiento,'ddmmyyyy')&Estado_civil&LSDateformat(Fecha_Ingreso,'ddmmyyyy')&Embargo&'TEL000000000000000000'&limitar(trim(RHPcodigo),5)&trim(DEemail)&Chr(13)&Chr(10)>
</cfloop>
<cfset archivo=GetTempFile( GetTempDirectory(), 'FGADATPER')>
<cffile action = "write" file = "#archivo#" output = "#salida#" nameconflict="overwrite">
<cfheader name="Content-Disposition" value="attachment; filename=FGADATPER.txt" ><!---charset="utf-8"---> 
<cfcontent type="text/plain;charset=windows-1252" file="#archivo#">