<!---<cf_dump var="ssssssssssssss">--->


<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfset action = "RelacionAumento.cfm">
<cfset modo = "CAMBIO">
<cfset modoDet = "ALTA">
<!---========= VARIABLES DE Traduccion ============---->
<cfinvoke Key="MSG_El_empleado_no_se_encuentra_nombrado" Default="El empleado no se encuentra nombrado"	returnvariable="MSG_El_empleado_no_se_encuentra_nombrado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Un_aumento_salarial_para_esta_fecha_ya_ha_sido_registrado_para_el_empleado_seleccionado" Default="Un aumento salarial para esta fecha ya ha sido registrado para el empleado seleccionado."	 returnvariable="MSG_Un_aumento_salarial_para_esta_fecha_ya_ha_sido_registrado_para_el_empleado_seleccionado" component="sif.Componentes.Translate" method="Translate"/>	
<!---========= FIN VARIABLES DE Traduccion ============---->
<!--- VERIFICA SI TIENE CONTROL PRESUPUESTARIO --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="540" default="" returnvariable="ControlP"/>
<!--- VERIFICA  SI USA ESTRUCTURA SALARIAL --->
<cfquery name="UsaTabla" datasource="#session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CSsalariobase = 1
</cfquery>

<cfquery name="rsComponenteSalarial" datasource="#Session.DSN#">
    select CSid
    from ComponentesSalariales
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and CSsalariobase = 1
</cfquery>

<cfset CSid = rsComponenteSalarial.CSid>
<cfif Usatabla.CSusatabla EQ 1>
	<cfset usaEstructuraSal = true>
<cfelse>
	<cfset usaEstructuraSal = false>
</cfif> 


<cfif not isdefined("Form.btnNuevo") and not isdefined("Form.btnNuevoD") and not isdefined("Form.btnAplicar")>
	<cfif isdefined("Form.btnAgregar")>
		<cfquery name="rsLote" datasource="#session.DSN#">
			select coalesce(max(RHAlote),0)+1  as lote
			from RHEAumentos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>  
		<cftransaction>
			<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
				insert into RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado,RHAtipo,RHTTid,RHVTid,RHAinactivos)
				values(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLote.lote#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfdesde)#">, 
					0,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHAtipo#">,
					<cfif isdefined('form.RHTTid') and LEN(TRIM(form.RHTTid))>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
					<cfelse>
                        null,
                        null
					</cfif>
					<cfif isdefined('form.Inactivos')>,1<cfelse>,0</cfif> )
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Aumento">
		</cftransaction>
		<cfset Form.RHAid = ABC_Aumento.identity>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">

	<cfelseif isdefined("Form.btnAgregarD")>
		<cfquery name="chkExists1" datasource="#Session.DSN#">
			select distinct RHCPlinea, RHVTid, RHTTid, LTid, 'N' as TLinea
			from RHEAumentos a, DatosEmpleado b, LineaTiempo c
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
                and a.Ecodigo = b.Ecodigo 
                and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
                and b.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
                and b.DEid = c.DEid
			<cfif isdefined('form.Inactivos')>
				and c.LThasta >= a.RHAfdesde
			<cfelse>
				and a.RHAfdesde between c.LTdesde and c.LThasta
               <!--- and a.RHAfdesde <= c.LThasta--->
			</cfif>
            union
            select distinct RHCPlinea, RHVTid, RHTTid, LTRid , 'R' as TLinea
			from RHEAumentos a, DatosEmpleado b, LineaTiempoR c
			where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
                and a.Ecodigo = b.Ecodigo 
                and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
                and b.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
                and b.DEid = c.DEid
			<cfif isdefined('form.Inactivos')>
				and c.LThasta >= a.RHAfdesde
			<cfelse>
				and a.RHAfdesde between c.LTdesde and c.LThasta
               <!--- and a.RHAfdesde <= c.LThasta--->
			</cfif>
            order by TLinea
		</cfquery>

        
		<cfif chkExists1.recordCount EQ 0>
			<cfthrow message="#MSG_El_empleado_no_se_encuentra_nombrado#">
		</cfif>

		<cfquery name="chkExists2" datasource="#Session.DSN#">
			select b.*
			from RHEAumentos ea, RHEAumentos a, RHDAumentos b
			where ea.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			and ea.RHAfdesde = a.RHAfdesde
			and a.RHAid = b.RHAid
			and b.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">
			and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
		</cfquery>
        
		<cfif chkExists2.recordCount GT 0>
			<cfthrow message="#MSG_Un_aumento_salarial_para_esta_fecha_ya_ha_sido_registrado_para_el_empleado_seleccionado#">
		</cfif>
        
        <cfset LvRHCPlinea 	= 0>
        <cfset LvRHVTid 	= 0>
        <cfset LvRHTTid		= 0>
        
        <cfloop query="chkExists1">
			<cfif usaEstructuraSal>
                <!--- SE TIENE QUE OBTENER EL SALARIO CORRESPONDIENTE --->
                <cfquery name="rsRHPClinea" datasource="#session.DSN#">
                    select coalesce(e.RHMCmonto,0) as SalarioBase, d.*
                    from RHCategoriasPuesto d
                    inner join RHMontosCategoria e
                        on e.RHCid = d.RHCid
                    inner join RHVigenciasTabla a
                        on a.Ecodigo = d.Ecodigo
                        and a.RHVTid = e.RHVTid
                    where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and d.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.RHCPlinea#">
                      and RHVTestado = 'A'
                      and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.RHVTid#">
                      and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.RHTTid#">
                </cfquery>
           </cfif>     
                <cfquery name="rsSalario" datasource="#session.DSN#">
                    select coalesce(dlt.DLTmonto,0) as Salario
                    <cfif chkExists1.TLinea EQ 'N'>
	                    from DLineaTiempo dlt
                        where LTid = #chkExists1.LTid#
					<cfelse>
	                    from DLineaTiempoR dlt
                        where LTRid = #chkExists1.LTid#
                    </cfif>
                    and CSid = #CSid#
                </cfquery>

           <cfquery name="ABC_Aumento" datasource="#Session.DSN#">
           		insert into RHDAumentos (RHAid, NTIcodigo, DEid, DEidentificacion, RHDtipo, RHDvalor, RHDporcentaje , 
                <cfif chkExists1.TLinea EQ 'N'>
	                    LTid
					<cfelse>
	                    LTRid
                    </cfif>
                , RHDsalario )
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#Form.NTIcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">, 
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">, 
                    <cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'M'>
                        <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHDvalor, ',', '', 'all')#">,
                        0,
                    <cfelseif isdefined("form.RHAtipo") and form.RHAtipo eq 'P'>
                        0,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHDporcentaje#">,
                    <cfelseif isdefined("form.RHAtipo") and form.RHAtipo eq 'T'>
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsRHPClinea.SalarioBase#">,
                        0,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.LTid#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsSalario.Salario#">
                    
                )
            </cfquery>
      <!---  </cfif>   --->
        </cfloop>
        
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">
	<cfelseif isdefined("Form.btnEliminar")>
		<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
			delete RHDAumentos
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
		<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
			delete RHEAumentos 
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
		</cfquery>
		<cfset modo = "ALTA">
		<cfset modoDet = "ALTA">
		<cfset action = "RelacionAumento-lista.cfm">

	<cfelseif isdefined("Form.btnEliminarD")>
    	<cfset vDEid = listtoarray(#form.DEid#)>
		<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
			delete RHDAumentos
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
            and DEid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid[1]#">
			<!---and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">--->
		</cfquery>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">

	<cfelseif isdefined("Form.btnCambiarD") and not usaEstructuraSal>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHDAumentos"
			redirect="RelacionAumento.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHDAlinea" 
			type1="numeric" 
			value1="#form.RHDAlinea#"
			field2="RHAid" 
			type2="numeric" 
			value2="#form.RHAid#">
		<cfquery name="ABC_Aumento" datasource="#Session.DSN#">
			update RHDAumentos
			   set RHDvalor = <cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'M'>#replace(Form.RHDvalor,',','','all' )#<cfelse>0</cfif>,
			   	   RHDporcentaje = <cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'P'>#replace(Form.RHDporcentaje,',','','all' )#<cfelse>0</cfif>
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			and RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHDAlinea#">
		</cfquery>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">

	<cfelseif isdefined("form.btnAgregarDCF")>
		<cfif isdefined("form.dependencias")>
			<cfquery name="rspath" datasource="#session.DSN#">
				select CFpath
				from CFuncional
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfquery>
		</cfif>

		<cfquery name="chkExists1" datasource="#session.DSN#">
			<!---insert into RHDAumentos (RHAid, NTIcodigo, DEidentificacion, RHDvalor, DEid, BMUsucodigo, RHDporcentaje, LTid, RHCPlinea)
            
            insert into RHDAumentos (RHAid, NTIcodigo, DEid, DEidentificacion, RHDtipo, RHDvalor, RHDporcentaje , 
                <cfif chkExists1.TLinea EQ 'N'> LTid <cfelse> LTRid</cfif>, RHDsalario )--->
                
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">, 
					de.NTIcodigo, 
					de.DEidentificacion, 
					<cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'M' >#replace(form.RHDvalorcf, ',', '', 'all')#<cfelse>0</cfif>,
					de.DEid, 
					#session.Usucodigo# ,
					<cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'P' >#replace(form.RHDporcentajecf, ',', '', 'all')#<cfelse>0</cfif>
                    , lt.LTid, lt.RHCPlinea,  'N' as TLinea
                from LineaTiempo lt, RHPlazas p, DatosEmpleado de, CFuncional cf
                    where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    <cfif isdefined('form.Inactivos')>
                        and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHAfdesde)#">
                    <cfelse>
                        and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHAfdesde)#"> between LTdesde and LThasta
                    </cfif>
                    and p.RHPid=lt.RHPid
                    and cf.CFid=p.CFid
                    and ( p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"> 
                            <cfif isdefined("form.dependencias")>
                                or cf.CFpath like '#rspath.CFpath#%'
                            </cfif>
                    )
                    and de.DEid=lt.DEid
                    and lt.LTsalario > 0
        
                    and not exists ( 	select 1
                                        from RHDAumentos
                                        where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
                                        and DEid = lt.DEid
                                        and LTid > 0 )
                                
              union
              select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">, 
					de.NTIcodigo, 
					de.DEidentificacion, 
					<cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'M' >#replace(form.RHDvalorcf, ',', '', 'all')#<cfelse>0</cfif>,
					de.DEid, 
					#session.Usucodigo# ,
					<cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'P' >#replace(form.RHDporcentajecf, ',', '', 'all')#<cfelse>0</cfif>
                    , lt.LTRid, lt.RHCPlinea,  'R' as TLinea
                from LineaTiempoR lt, RHPlazas p, DatosEmpleado de, CFuncional cf
                    where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    <cfif isdefined('form.Inactivos')>
                        and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHAfdesde)#">
                    <cfelse>
                        and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHAfdesde)#"> between LTdesde and LThasta
                    </cfif>
                    and p.RHPid=lt.RHPid
                    and cf.CFid=p.CFid
                    and ( p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#"> 
                            <cfif isdefined("form.dependencias")>
                                or cf.CFpath like '#rspath.CFpath#%'
                            </cfif>
                    )
                    and de.DEid=lt.DEid
                    and lt.LTsalario > 0
        
                    and not exists ( 	select 1
                                        from RHDAumentos
                                        where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
                                        and DEid = lt.DEid
                                        and LTRid > 0 )
		</cfquery>

		<cfset LvRHCPlinea 	= 0>
        <cfset LvRHVTid 	= 0>
        <cfset LvRHTTid		= 0>	
        
        <cfquery name="rsRAumento" datasource="#session.DSN#">
            select *
            from RHEAumentos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and RHAestado = 0
              and RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAid#">
        </cfquery>

        <cfloop query="chkExists1">
			<cfif usaEstructuraSal>
                <!--- SE TIENE QUE OBTENER EL SALARIO CORRESPONDIENTE --->
                <cfquery name="rsRHPClinea" datasource="#session.DSN#">
                    select coalesce(e.RHMCmonto,0) as SalarioBase, d.*
                    from RHCategoriasPuesto d
                    inner join RHMontosCategoria e
                        on e.RHCid = d.RHCid
                    inner join RHVigenciasTabla a
                        on a.Ecodigo = d.Ecodigo
                        and a.RHVTid = e.RHVTid
                    where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and d.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.RHCPlinea#">
                      and RHVTestado = 'A'
                      and a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRAumento.RHVTid#">
                      and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRAumento.RHTTid#">
                </cfquery>
            </cfif>
           <cfquery name="rsSalario" datasource="#session.DSN#">
                select coalesce(dlt.DLTmonto,0) as Salario
                <cfif chkExists1.TLinea EQ 'N'>
                    from DLineaTiempo dlt
                    where LTid = #chkExists1.LTid#
                <cfelse>
                    from DLineaTiempoR dlt
                    where LTRid = #chkExists1.LTid#
                </cfif>
                and CSid = #CSid#
            </cfquery>


           <cfquery name="ABC_Aumento" datasource="#Session.DSN#">
           		insert into RHDAumentos (RHAid, NTIcodigo, DEid, DEidentificacion, RHDtipo, RHDvalor, RHDporcentaje , 
                <cfif chkExists1.TLinea EQ 'N'>
	                    LTid
					<cfelse>
	                    LTRid
                    </cfif>
                , RHDsalario )
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#chkExists1.NTIcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.DEid#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#chkExists1.DEidentificacion#">, 
                    <cfqueryparam cfsqltype="cf_sql_bit" value="0">, 
                    <cfif isdefined("form.RHAtipo") and form.RHAtipo eq 'M'>
                        <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHDvalorcf, ',', '', 'all')#">,
                        0,
                    <cfelseif isdefined("form.RHAtipo") and form.RHAtipo eq 'P'>
                        0,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#Form.RHDporcentajecf#">,
                    <cfelseif isdefined("form.RHAtipo") and form.RHAtipo eq 'T'>
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsRHPClinea.SalarioBase#">,
                        0,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#chkExists1.LTid#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsSalario.Salario#">
               )
            </cfquery>
        </cfloop>
	</cfif>	
	
	<cfif isdefined("Form.btnAgregarD") or isdefined("Form.btnCambiarD") or isdefined("form.btnAgregarDCF") >
		<cftransaction>	
			<!--- REALIZA EL SIGUIENTE PROCESO para todos los empleados de la relacion: 
					1. 	Si el tipo de aumento es por monto, calcula el porcentaje asoiado al aumento.
						Debe modificar el campo porcentaje de la tabla
					2.	Si el tipo de aumento es por porcentaje, calcula el monto asociado al porcentaje.
			--->
			<cfquery name="rs_salarios" datasource="#session.DSN#">
				select a.*, a.RHAtipo as tipo
				from RHEAumentos a
				where a.RHAid = #Form.RHAid#
			</cfquery>
            
			<!--- aumento por porcentaje --->
			<cfif rs_salarios.tipo eq 'P'>
				<cfquery datasource="#session.DSN#">
                    update RHDAumentos set RHDvalor = coalesce((RHDsalario * (RHDAumentos.RHDporcentaje/100)),0) where RHAid = #Form.RHAid#
				</cfquery>
			
			<!--- aumento por monto --->
			<cfelseif rs_salarios.tipo eq 'M'>
				<cfquery datasource="#session.DSN#">
                	update RHDAumentos set RHDporcentaje = coalesce((case when RHDsalario > 0 then ((RHDAumentos.RHDvalor*100)/RHDsalario) else 0 end), 0) where RHAid = #Form.RHAid#
				</cfquery>
			</cfif>
		</cftransaction>
	</cfif>
</cfif>

<cfoutput>
<cfif isdefined("btnAplicar") and isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
	<form action="/cfmx/rh/nomina/operacion/RelacionAumento-listaSql.cfm" method="post" name="sql">
		<input name="chk" type="hidden" value="#Form.RHAid#">
		<input name="btnAplicar" type="hidden" value="Aplicar">
	</form>
<cfelse>
	<form action="#action#" method="post" name="sql">
		<cfif modo EQ "CAMBIO" and isdefined("Form.RHAid") and Len(Trim(Form.RHAid)) NEQ 0>
			<input name="RHAid" type="hidden" value="#Form.RHAid#">
			<cfif isdefined('form.Inactivos')>
			<input name="Inactivos" type="hidden" value="#Form.Inactivos#">
			</cfif>
		</cfif>
		<cfif modoDet EQ "CAMBIO" and isdefined("Form.RHDAlinea") and Len(Trim(Form.RHDAlinea)) NEQ 0>
			<input name="RHDAlinea" type="hidden" value="#Form.RHDAlinea#">
		</cfif>
		<cfif isdefined("Form.btnBuscar")>
			<input name="btnBuscar" type="hidden" value="Buscar">
			<cfif isdefined("Form.DEidentificacion") and Len(Trim(Form.DEidentificacion)) NEQ 0>
				<input name="DEid" type="hidden" value="#Form.DEid#">
				<input name="NTIcodigo" type="hidden" value="#Form.NTIcodigo#">
				<input name="DEidentificacion" type="hidden" value="#Form.DEidentificacion#">
			</cfif>
		</cfif>
		<cfif action EQ "RelacionAumento.cfm">
			<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
		</cfif>
	</form>
</cfif>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
