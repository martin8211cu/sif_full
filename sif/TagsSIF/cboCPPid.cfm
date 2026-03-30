<cfset def = QueryNew("CPPid")>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.FechaSugTC" default="" type="String"> <!--- Fecha para sugerir el tipo de cambio --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.Conlis" default="N" type="String"> <!--- Si es conlis 'S' o no 'N' --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.CPPid" default="CPPid" type="string"> <!--- Nombre del código de la moneda --->
<cfparam name="Attributes.onChange" default="" type="string"> <!--- funciones javascript en el evento onchange --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.value" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.IncluirTodos" default="no" type="boolean"> <!--- incluir la opcion -1=(Todos...)  --->
<cfparam name="Attributes.disabled" default="no" type="boolean"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.CPPestado" default="" type="string"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.order" default="desc" type="string"> <!--- Lista de estados permitidos  --->
<cfparam name="Attributes.session" default="no" type="boolean">
<cfparam name="Attributes.createform" default="" type="String"> <!--- Crea form de Nombre createform --->

<cfif Attributes.session>
	<cfif isdefined("form.#Attributes.CPPid#")>
		<cfset Session.CPPid = form[Attributes.CPPid]>
    </cfif>
	<cfparam name="Session.CPPid" default="-1">
	<cfset Attributes.value = Session.CPPid>
	<cfset form[Attributes.CPPid] = Session.CPPid>
</cfif>
<cfif isdefined('Session.Ecodigo')>
	<cfparam name="Attributes.Ecodigo" default="#Session.Ecodigo#" type="String"> <!--- Empresa --->
<cfelse>
	<cfparam name="Attributes.Ecodigo" default="" type="String"> <!--- Empresa --->
</cfif>

<cfif Len(Trim(Attributes.Ecodigo)) EQ 0>
	<cfabort>
</cfif>
 
<cf_dbfunction name="date_part"	args="YYYY, CPPfechaHasta" returnvariable="dp_CPPfechaHasta">
<cf_dbfunction name="date_part"	args="YYYY, CPPfechaDesde"returnvariable="dp_CPPfechaDesde">

<cfinclude template="../Utiles/sifConcat.cfm">
<cfquery name="rsCPPeriodos" datasource="#Session.DSN#">
	select 	CPPid, 
			CPPtipoPeriodo, 
			CPPfechaDesde, 
			CPPfechaHasta, 
			CPPanoMesDesde, 
			CPPanoMesHasta, 
			CPPestado,
			'Presupuesto ' #_Cat#
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case <cf_dbfunction name="date_part"	args="MM, CPPfechaDesde"> when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat#   <cf_dbfunction name="to_char" args="#dp_CPPfechaDesde#">
				#_Cat# ' a ' #_Cat# 
				case <cf_dbfunction name="date_part"	args="MM, CPPfechaHasta"> when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="#dp_CPPfechaHasta#">
			as Descripcion				
	 from CPresupuestoPeriodo p
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif Attributes.CPPestado EQ "10">
	  and CPPestado in (0,1)
	  and 
		( 
	  		select count(1) 
	          from CVersion v 
			 where v.Ecodigo=p.Ecodigo 
			   and v.CPPid		= p.CPPid
			   and v.CVtipo		= '2'
			   and v.CVaprobada	= 1
		) = 0
	<cfelseif Attributes.CPPestado NEQ "">
	  and CPPestado in (#Attributes.CPPestado#)
	</cfif>
	order by CPPfechaDesde #Attributes.Order#
</cfquery>
<cfif not Attributes.IncluirTodos AND Attributes.value EQ -1>
    <cfquery name="rsSQL" dbtype="query">
        select CPPid
          from rsCPPeriodos
         where #DateFormat(now(),"YYYYMM")# between CPPanoMesDesde and CPPanoMesHasta
    </cfquery>
    <cfif rsSQL.CPPid NEQ "">
		<cfset Attributes.value = rsSQL.CPPid>
        <cfif Attributes.session>
            <cfset session.CPPid = rsSQL.CPPid>
			<cfset form[Attributes.CPPid] = Session.CPPid>
        </cfif>
    <cfelseif rsCPPeriodos.CPPid NEQ "">
		<cfset Attributes.value = rsCPPeriodos.CPPid>
        <cfif Attributes.session>
            <cfset session.CPPid = rsCPPeriodos.CPPid>
			<cfset form[Attributes.CPPid] = Session.CPPid>
        </cfif>
	</cfif>
</cfif>

<cfoutput>
<cfif Attributes.createform NEQ "">
	<form name="#Attributes.createform#" id="#Attributes.createform#" method="post">
</cfif>
	<select name="#Attributes.CPPid#" 
		id="#Attributes.CPPid#" 
		<cfif Attributes.disabled> disabled </cfif>
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		<cfif Len(Trim(Attributes.onChange)) GT 0> onChange="javascript:#Attributes.onChange#"	</cfif>
	>
</cfoutput>
<cfif Attributes.IncluirTodos>
	<option value="-1">(Todos los períodos...)</option>
</cfif>

<cfoutput query="rsCPPeriodos"> 
	<option value="#rsCPPeriodos.CPPid#"
   <cfif isdefined("Attributes.value") and Attributes.value NEQ "">
		<cfif trim(rsCPPeriodos.CPPid) EQ trim(Attributes.value)>selected</cfif>
   <cfelseif isdefined('Attributes.query') and ListLen('Attributes.query.columnList') GT 0 and #Attributes.query.CPPid# NEQ -1>
		<cfif rsCPPeriodos.CPPid EQ Attributes.query.CPPid >selected</cfif>
   <cfelseif rsCPPeriodos.CPPid EQ rsMonedaLocal.Mcodigo >selected</cfif>
	>						
	#rsCPPeriodos.Descripcion#</option>
</cfoutput>
</select>

<cfif Attributes.createform NEQ "">
	</form>
</cfif>
