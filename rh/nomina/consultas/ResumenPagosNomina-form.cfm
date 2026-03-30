<!--- OPARRALES 2019-01-09
	- Validacion para mostrar la nominas Aplicadas o en preparacion.
 --->
	<!--- Tabla temporal de resultados --->

    <cf_dbtemp name="Rfaltas" returnvariable="Rfaltas">
    	<cf_dbtempcol name="RCNid"     		type="Numeric"      mandatory="no">
	    <cf_dbtempcol name="DEid"     		type="int"          mandatory="no">
        <cf_dbtempcol name="RHTfactorfalta"	type="money"     	mandatory="no">
        <cf_dbtempcol name="PEcantdias"		type="money"     	mandatory="no">
        <cf_dbtempcol name="PEsalario"		type="money"     	mandatory="no">
        <cf_dbtempcol name="MtoFalta"		type="money"     	mandatory="no">
    </cf_dbtemp>

	<cf_dbtemp name="salidaRConceptos" returnvariable="salidaRConceptos">
		<cf_dbtempcol name="RCNid"			type="numeric"     	mandatory="no">
        <cf_dbtempcol name="SalarioBase"	type="money"     	mandatory="no">
        <cf_dbtempcol name="ValesDespensa"	type="money"     	mandatory="no">
        <cf_dbtempcol name="TotEspecie"		type="money"     	mandatory="no">
        <cf_dbtempcol name="TotPercepciones"type="money"     	mandatory="no">
        <cf_dbtempcol name="TotDeducciones"	type="money"     	mandatory="no">
        <cf_dbtempcol name="TotCargas"		type="money"     	mandatory="no">
        <cf_dbtempcol name="TotEfectivo"	type="money"     	mandatory="no">
        <cf_dbtempcol name="NetoPagado"		type="money"     	mandatory="no">
        <cf_dbtempcol name="TotGravable"	type="money"     	mandatory="no">
        <cf_dbtempcol name="TotSubsidio"	type="money"     	mandatory="no">
        <cf_dbtempcol name="ISPT"			type="money"     	mandatory="no">
        <cf_dbtempcol name="DiasFalta"		type="money"     	mandatory="no">
        <cf_dbtempcol name="MtoFalta"		type="money"     	mandatory="no">


	</cf_dbtemp>

<cfset idOficina = #codOficina#> <!--- c�digo de la oficina --->

<cfset vSalarioEmpeleado 	= 'HSalarioEmpleado'>
<cfset vRCalculoNomina 		= 'HRCalculoNomina'>
<cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
<cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
<cfset vPagosEmpleado 		= 'HPagosEmpleado'>
<cfset vCargascalculo		= 'HCargasCalculo'>

<cfquery name="rsNomina" datasource="#session.dsn#">
	select *
	from
		RCalculoNomina a
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
</cfquery>

<cfif rsNomina.RecordCount gt 0>
	<cfset vSalarioEmpeleado 	= 'SalarioEmpleado'>
	<cfset vRCalculoNomina 		= 'RCalculoNomina'>
	<cfset vDeduccionesCalculo 	= 'DeduccionesCalculo'>
	<cfset vIncidenciasCalculo 	= 'IncidenciasCalculo'>
	<cfset vPagosEmpleado 		= 'PagosEmpleado'>
	<cfset vCargascalculo		= 'CargasCalculo'>
</cfif>

<cfquery name="rsNomina" datasource="#session.DSN#">
	select RCNid, c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from #vRCalculoNomina# a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	and a.Ecodigo = b.Ecodigo
</cfquery>

<!--- DATOS DE LA NOMINA ---->
<cfquery name="rsEmpleados" datasource="#session.DSN#">
	insert into #salidaRConceptos# ( RCNid, SalarioBase, ValesDespensa, TotEspecie, ISPT, TotPercepciones, TotEfectivo,
    TotDeducciones,  NetoPagado, TotGravable, TotSubsidio,DiasFalta, MtoFalta, TotCargas )
    select d.RCNid, sum(d.SEsalariobruto), sum(d.SEespecie), sum(d.SEespecie), sum(d.SErenta), sum(d.SEsalariobruto+d.SEincidencias), sum(d.SEliquido),
     sum(d.SErenta), 0, 0, 0, 0, 0, 0
 	from #vSalarioEmpeleado# d
<!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista--->
	<cfif idOficina gt 0>
		inner join CalendarioPagos cp
		on d.RCNid = cp.CPid
		inner join LineaTiempo lt
		on lt.DEid = d.DEid
		inner join Oficinas o
		on o.Ocodigo = lt.Ocodigo
	</cfif>
    where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
    <!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista.
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos --->
	<cfif idOficina gt 0>
		and o.Ocodigo = #idOficina#
		and (lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta)
	</cfif>
	group by RCNid
</cfquery>

<!--- DATOS DE LA Faltas ---->
<cfquery name="rsInsFaltas" datasource="#session.DSN#">
	insert into #Rfaltas# ( RCNid, DEid, RHTfactorfalta, PEcantdias, PEsalario, MtoFalta)
        select a.RCNid,a.DEid, b.RHTfactorfalta, a.PEcantdias,   a.PEsalario,
    (b.RHTfactorfalta *((a.PEsalario/30)*a.PEcantdias))
    from #vPagosEmpleado# a
        inner join RHTipoAccion b
            on a.RHTid =  b.RHTid
            and b.RHTcomportam in (13)
	<cfif idOficina gt 0>
		inner join CalendarioPagos cp
		on a.RCNid = cp.CPid
		inner join LineaTiempo lt
		on lt.DEid = a.DEid
		inner join Oficinas o
		on o.Ocodigo = lt.Ocodigo
	</cfif>
    where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	<!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos--->
	<cfif idOficina gt 0>
		and o.Ocodigo = #idOficina#
		and (lt.RHTid = 4 or lt.RHTid = 6)
		and (lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta
		or (lt.LThasta between cp.CPdesde and cp.CPhasta
		and lt.LTDesde between cp.CPdesde and cp.CPhasta))
	</cfif>
</cfquery>


<cfquery name="rsFaltas" datasource="#session.DSN#">
    select RCNid, Sum(PEcantdias) as CantDias, sum(MtoFalta) as MtoFalta
    from #Rfaltas#
    group by RCNid
</cfquery>

<!--- DATOS DE LA Incidencias Percepciones  ---->
<cfquery name="rsPercepciones" datasource="#session.DSN#">
    select ic.CIid,i.CIdescripcion, ic.RCNid, sum(ic.ICmontores) as MtoIncidencia
        from #vIncidenciasCalculo# ic
            inner join CIncidentes i
                on ic.CIid = i.CIid
		<!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista--->
	<cfif idOficina gt 0>
		inner join LineaTiempo lt
		on lt.DEid = ic.DEid
		inner join CalendarioPagos cp
		on ic.RCNid = cp.CPid
	</cfif>
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
            and ic.CIid not in ( select CIid
                                    from ComponentesSalariales
                                    where Ecodigo = #session.Ecodigo#
                                    and CSsalarioEspecie = 1)
            and i.Ecodigo = #session.Ecodigo#
<!---   Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos--->
	<cfif idOficina gt 0>
		and lt.Ocodigo = #idOficina#
		and (lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta)
    </cfif>
		group by ic.CIid,i.CIdescripcion, ic.RCNid
</cfquery>

<cfquery name="rsMtoPercepciones" dbtype="query">
    select sum(MtoIncidencia) as MtoIncidencia
        from rsPercepciones
</cfquery>



<cfquery name="rsUpdTotales" datasource="#session.DSN#">
	update #salidaRConceptos# set
    	  DiasFalta = <cfif isdefined('rsFaltas') and rsFaltas.RecordCount NEQ 0>#rsFaltas.CantDias#<cfelse> 0</cfif>
        , MtoFalta = <cfif isdefined('rsFaltas') and rsFaltas.RecordCount NEQ 0>#rsFaltas.MtoFalta#<cfelse> 0</cfif>
<!---        , TotPercepciones = TotPercepciones + #rsPercepciones.MtoIncidencia# + ValesDespensa---->
</cfquery>



<!--- DATOS DE LA CARGAS ---->
<cfquery name="rsCargas" datasource="#session.DSN#">
    select cc.DClinea,cc.RCNid, dc.DCdescripcion, sum(cc.CCvaloremp) as MtoCarga
    from #vCargascalculo# cc
        inner join DCargas dc
		on cc.DClinea = dc.DClinea
		<cfif idOficina gt 0>
			inner join LineaTiempo lt
			on lt.DEid = cc.DEid
			inner join CalendarioPagos cp
			on cc.RCNid = cp.CPid
    	</cfif>
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
        	and CCvaloremp > 0
		<!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos--->
	<cfif idOficina gt 0>
		and (lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta)
		and lt.Ocodigo = #idOficina#
		and dc.Ecodigo = #session.Ecodigo#
    </cfif>
        group by cc.DClinea,cc.RCNid, dc.DCdescripcion
</cfquery>

<cfquery name="rsMtoCargas" dbtype="query">
    select sum(MtoCarga) as MtoCarga
        from rsCargas
</cfquery>

<cfquery name="rsUpdTotales" datasource="#session.DSN#">
	update #salidaRConceptos# set
           TotCargas	= TotCargas + <cfif isdefined('rsMtoCargas') and rsMtoCargas.RecordCount NEQ 0>#rsMtoCargas.MtoCarga#<cfelse> 0</cfif>
</cfquery>

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2033" default="" returnvariable="vSubsidio"/>

<!--- DATOS DE LA Subsidio Salario ---->
<cfquery name="rsSubsidio" datasource="#session.DSN#">
    select a.RCNid, sum(a.DCvalor) as MtoSubsidio
        from #vDeduccionesCalculo# a
        inner join DeduccionesEmpleado b
            on a.Did = b.Did
            and b.TDid = #vSubsidio#
	<cfif idOficina gt 0>
		inner join CalendarioPagos cp
		on a.RCNid = cp.CPid
		inner join LineaTiempo lt
		on lt.DEid = a.DEid
		inner join Oficinas o
		on o.Ocodigo = lt.Ocodigo
    </cfif>
        where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
    <!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos--->
	<cfif idOficina gt 0>
		and lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta
		and o.Ocodigo = #idOficina#
    </cfif>
		group by a.RCNid
</cfquery>

<!--- DATOS DE LA Deducciones ---->
<cfquery name="rsDeducciones" datasource="#session.DSN#">
    select a.RCNid,c.TDid,c.TDdescripcion, sum(a.DCvalor) as MtoDeduc
    from #vDeduccionesCalculo# a
    inner join DeduccionesEmpleado b
        on a.Did = b.Did
    inner join TDeduccion c
        on b.TDid = c.TDid
	<cfif idOficina gt 0>
		inner join CalendarioPagos cp
		on a.RCNid = cp.CPid
		inner join LineaTiempo lt
		on lt.DEid = a.DEid
		inner join Oficinas o
		on o.Ocodigo = lt.Ocodigo
    </cfif>
    where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
        and b.TDid <> #vSubsidio#
	<!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos--->
	<cfif idOficina gt 0>
		and lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta
		and o.Ocodigo = #idOficina#
    </cfif>
    group by a.RCNid,c.TDid,c.TDdescripcion
</cfquery>

<cfquery name="rsMtoDeducciones" dbtype="query">
    select sum(MtoDeduc) as MtoDeduc
        from rsDeducciones
</cfquery>

<cfquery name="rsGravables" datasource="#session.DSN#">
    <!---select ic.CIid,i.CIdescripcion, ic.RCNid, sum(ic.ICmontores)--->
    select ic.RCNid, sum(ic.ICmontores) as MtoIncidenciasGravables
        from #vIncidenciasCalculo# ic
            inner join CIncidentes i
                on ic.CIid = i.CIid
		<cfif idOficina gt 0>
			inner join CalendarioPagos cp
			on ic.RCNid = cp.CPid
			inner join LineaTiempo lt
			on lt.DEid = ic.DEid
			inner join Oficinas o
			on o.Ocodigo = lt.Ocodigo
    	</cfif>
            and CInorenta = 0
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
            and ic.CIid  not in ( select CIid
                                    from ComponentesSalariales
                                    where Ecodigo = #session.Ecodigo#
                                    and CSsalarioEspecie = 1)
            and i.Ecodigo = #session.Ecodigo#
		<!--- Esta parte se encarga de filtrar la informaci�n por oficinas
		si el idOficina es mayor a cero, el contenido del if se ejecuta.
	 	el idOficina lo traigo desde la vista
	 	Las fechas desde y hasta son importantes, debido a que una regla dice
	 	que se debe tomar la ultima oficina en la que estuvo el empleado para
	 	hacer los respectivos calculos--->
		<cfif idOficina gt 0>
			and lt.LTdesde <= cp.CPhasta and lt.LThasta >= cp.CPhasta
			and o.Ocodigo = #idOficina#
    	</cfif>
        group by ic.RCNid
</cfquery>

<cfquery name="rsUpdTotales" datasource="#session.DSN#">
	update #salidaRConceptos# set
    	   TotSubsidio 		= <cfif isdefined('rsSubsidio') and rsSubsidio.RecordCount NEQ 0>#rsSubsidio.MtoSubsidio# <cfelse> 0</cfif>
           ,TotDeducciones	= TotDeducciones  + TotCargas  <!---- + MtoFalta no tomar en cuenta Eunice 20120511----->
		   /* + <cfif isdefined('rsSubsidio') and rsSubsidio.RecordCount NEQ 0>#rsSubsidio.MtoSubsidio# <cfelse> 0</cfif> */
           + <cfif isdefined('rsMtoDeducciones') and rsMtoDeducciones.RecordCount NEQ 0>#rsMtoDeducciones.MtoDeduc#<cfelse> 0</cfif>
           ,TotGravable 	= <cfif isdefined('rsGravables') and rsGravables.RecordCount NEQ 0>#rsGravables.MtoIncidenciasGravables#<cfelse>0</cfif>
</cfquery>

<cfquery name="rsUpdTotales" datasource="#session.DSN#">
	update #salidaRConceptos# set
    	   TotEfectivo 		= TotPercepciones - TotDeducciones
         , NetoPagado 		= TotPercepciones - TotDeducciones
</cfquery>


<cfquery name="rsSalida" datasource="#session.DSN#">
    select *
    from #salidaRConceptos#
</cfquery>


<cfinclude template="ResumenPagosNomina-Rep.cfm">
