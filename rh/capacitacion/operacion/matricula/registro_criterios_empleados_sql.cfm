<cfset DEBUG=false>
<cfsetting requesttimeout="36000">
<cfparam name="FORM.RHRCid" type="numeric">
<cfparam name="FORM.CFIDLIST" type="string" default="">
<cfparam name="FORM.ODIDLIST" type="string" default="">
<cfparam name="FORM.EMPLEADOIDLIST" type="string" default="">
<cfparam name="FORM.PUESTOIDLIST" type="string" default="">
<cfparam name="FORM.OPT" type="numeric" default="0"><!--- 0 = Centro Funcional, 1 = Oficina / Departamento--->
<cfparam name="FORM.PARAMS" type="string" default="">
<cfparam name="FORM.fechaini" type="string" default="">
<cfparam name="FORM.fechafin" type="string" default="">
<cfparam name="FORM.FECHA" type="string" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
<cfif isdefined("FORM.DEID") and len(trim(FORM.DEID)) eq 0><cfset FORM.DEID = 0></cfif>
<cfparam name="FORM.DEID" type="numeric" default="0">
<cfparam name="FORM.DEIDLIST" type="string" default="">

<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		set nocount on
		select CFid, #nivel# as nivel, null as CFidresp
		from CFuncional
		where CFid = #arguments.cfid#
		set nocount off
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		set nocount on
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = #session.Ecodigo#
		set nocount off
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>

<cffunction name="convertListItemsToString" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset arrstr[i] = "'" & arr[i] & "'">
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="processpuesto" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<cffunction name="processod" returntype="string">
	<cfargument name="list" type="string">
	<cfreturn convertListItemsToString(list)>
</cffunction>

<cffunction name="processcf" returntype="string">
	<cfargument name="list" type="string">
	<cfset arr = ListToArray(list)>
	<cfset arrstr = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(arr)#" index="i">
		<cfset cf = ListToArray(arr[i],'|')>
		<cfif cf[2] eq 1>
			<cfset cfs = getCentrosFuncionalesDependientes(cf[1])>
			<cfloop query="cfs">
				<cfset ArrayAppend(arrstr,cfid)>
			</cfloop>
		<cfelse>
			<cfset ArrayAppend(arrstr,cf[1])>
		</cfif>
	</cfloop>
	<cfreturn ArrayToList(arrstr)>
</cffunction>

<cffunction name="getListaEmpleados" returntype="query">
	<cfargument name="fechaini" required="no" type="string" default="#FORM.fechaini#">
	<cfargument name="fechafin" required="no" type="string" default="#FORM.fechafin#">
	<cfargument name="opt" required="no" type="numeric" default="#FORM.OPT#">
	<cfargument name="cfidlist" required="no" type="string" default="#FORM.CFIDLIST#">
	<cfargument name="odidlist" required="no" type="string" default="#FORM.ODIDLIST#">
	<cfargument name="empleadoidlist" required="no" type="string" default="#FORM.EMPLEADOIDLIST#">
	<cfargument name="puestoidlist" required="no" type="string" default="#FORM.PUESTOIDLIST#">
	<cfargument name="deid" required="no" type="numeric" default="#FORM.DEID#">
	<cfargument name="deidlist" required="no" type="string" default="#FORM.DEIDLIST#">
	<cfparam name="FORM.FECHA" type="string" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
	<cf_dbfunction name="to_char" args="c.Ocodigo" returnvariable="vROcodigo">
	<cf_dbfunction name="to_char" args="c.Dcodigo" returnvariable="vRDcodigo">
	<cf_dbfunction name="OP_concat"	 returnvariable="concate"><!--- se genera concatenador y se concatena por medio de CFusion por problemas del tag--->
	<cfset vRconcat=vROcodigo&#concate#>
	<cfset vRconcat=vRconcat&"'|'"&#concate#>
	<cfset vRconcat=vRconcat&vRDcodigo>
	<!---<cf_dbfunction name="concat" args="#vROcodigo# ,'|',#vRDcodigo#" returnvariable="vRconcat">--->


	<cfquery name="rs" datasource="#session.dsn#">
		select 
			a.DEid as IDEmpleado, 
			(select min(l.DEid) 
					from LineaTiempo l 
					where l.RHPid = c.RHPid 
					<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
						and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= l.LTdesde) as Jefe, 
					<cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
						and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= l.LTdesde ) as Jefe, 
					</cfif>
			(select min(l.DEid) 
					from LineaTiempo l 
					where l.RHPid = c2.RHPid 
					<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
						and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= l.LTdesde) as Jefe2, 
					<cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
						and <cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= l.LTdesde ) as Jefe2, 
					</cfif>
			
			c.CFidresp, 
			a.RHPid, 
			c.RHPid, 
			a.RHPcodigo
		from LineaTiempo a
		inner join RHPlazas b 
			on a.RHPid = b.RHPid
		inner join CFuncional c 
			on b.Ecodigo = c.Ecodigo
			and b.CFid = c.CFid
		left outer join CFuncional c2
			on c.CFidresp = c2.CFid
		where 
		<cfif isdefined ('form.fechaini') and len(trim(form.fechaini)) gt 0 and form.radfecha eq 0>
			<cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechaini,'dd-mm-yyyy')#'"> >= LTdesde 
		<cfelseif isdefined ('form.fechafin') and len(trim(form.fechafin)) gt 0 and form.radfecha neq 0>
			<cf_dbfunction name="to_date" args="'#LSDateFormat(FORM.fechafin,'dd-mm-yyyy')#'"> <= LTdesde 
		</cfif>
		and #now()#  between a.LTdesde and a.LThasta
		and b.Ecodigo = #session.Ecodigo#
		<cfif arguments.deid gt 0>
			and a.DEid = #arguments.deid#
		</cfif>
		<cfif len(trim(arguments.deidlist)) gt 0>
			and a.DEid in (#arguments.deidlist#)
		</cfif>		  
		<cfif len(trim(arguments.empleadoidlist)) gt 0>		  	
			and a.DEid in (#arguments.empleadoidlist#)
		</cfif>		
		<cfif len(trim(arguments.puestoidlist)) gt 0>
			and a.RHPcodigo in (#processpuesto(arguments.puestoidlist)#)
		</cfif>
	<cfif arguments.opt eq 0>
		<cfif len(trim(arguments.cfidlist)) gt 0>
			and c.CFid in (#processcf(arguments.cfidlist)#)
		</cfif>
		<cfelse>	
		<cfif len(trim(arguments.odidlist)) gt 0>
			and (#PreserveSingleQuotes(vRconcat)# in (#processod(arguments.odidlist)#))
		</cfif>
		</cfif>
	</cfquery>
	
	<cfreturn rs>
</cffunction>

<cftransaction>

<cfset RSEMPL = getListaEmpleados()>

<cfif RSEMPL.RECORDCOUNT>
	<cfloop query="RSEMPL">
		<cfquery datasource="#Session.DSN#"  name="rshaydatos">
			select 1 from RHDRelacionCap where RHRCid = #FORM.RHRCid# and DEid = #RSEMPL.IDEmpleado# 
		</cfquery>
		<cfif isdefined("rshaydatos") and rshaydatos.recordCount eq 0>
			<cfquery datasource="#Session.DSN#"  >
				insert into RHDRelacionCap 
				(RHRCid, DEid)
				values (#FORM.RHRCid#, #RSEMPL.IDEmpleado#)
			</cfquery>
		<cfelse>
			<cfquery datasource="#Session.DSN#"  >
				update RHRelacionCap 
				set RHRCestado = 30 
				where RHRCid = #FORM.RHRCid# 
				and RHRCestado = 10
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<CFIF DEBUG>
	<cfdump var="#form#" label="form">
	<cfdump var="#RSEMPL#" label="rsEmpl">
	<cfquery name="rsRHRelacionCap" datasource="#Session.DSN#">
		select * from RHRelacionCap where RHRCid = #FORM.RHRCid#
	</cfquery>
	<cfdump var="#rsRHRelacionCap#" label="rsRHRelacionCap">
	<cfquery name="rsRHDRelacionCap" datasource="#Session.DSN#">
		select * from RHDRelacionCap where RHRCid = #FORM.RHRCid# <cfif FORM.DEID gt 0> and DEid = #FORM.DEID#</cfif> <cfif len(trim(FORM.DEIDLIST)) gt 0> and DEid in (#FORM.DEIDLIST#)</cfif>
	</cfquery>
	<cfdump var="#rsRHDRelacionCap#" label="rsRHDRelacionCap">
	<cftransaction action = "rollback"/>
	<cfabort>
</CFIF>

</cftransaction>

<cfif isdefined("FORM.BTNGENERAREMPL") and FORM.BTNGENERAREMPL eq 1>
	<!--- ES INCLUIDO DESDE EL ARCHIVO REGISTRO_CRITERIOS_EMPLEADOS_LISTA_SQL, EL CONTINUA LA EJECUCION--->
<cfelse>
	<cflocation url="index.cfm?RHRCid=#FORM.RHRCid#&SEL=3">
</cfif>


