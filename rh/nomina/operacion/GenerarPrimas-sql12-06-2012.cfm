<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfset vDebug = false>

<cf_dbtemp name="tmpPrimas" returnvariable="PrimaVac" datasource="#session.DSN#">
    <cf_dbtempcol name="DEid" 				type="numeric" mandatory="no">
    <cf_dbtempcol name="DEidentificacion"	type="varchar(60)" mandatory="no">
    <cf_dbtempcol name="DEnombre" 			type="varchar(100)" mandatory="no">
    <cf_dbtempcol name="DEapellido1" 		type="varchar(80)" mandatory="no">
    <cf_dbtempcol name="DEapellido2" 		type="varchar(80)" mandatory="no">
    <cf_dbtempcol name="EVmes" 				type="numeric" mandatory="no">
    <cf_dbtempcol name="EVdia" 				type="numeric" mandatory="no">
    <cf_dbtempcol name="EVfantig" 			type="datetime" mandatory="no">
    <cf_dbtempcol name="EVfecha" 			type="datetime" mandatory="no">
    <cf_dbtempcol name="FIncidencia" 		type="datetime" mandatory="no">
    <cf_dbtempcol name="MontoPrima" 		type="money" mandatory="no">
    <cf_dbtempcol name="Cantidad" 			type="money" mandatory="no">
    
</cf_dbtemp>



	<cfset Fdesde = #form.FechaDesde#>
    <cfset Fhasta = Dateadd('d',#form.DiasT#, #form.FechaDesde#)>
    <cfset Fhasta = #LSDateFormat(Fhasta, "dd/mm/yyyy")#  >

    <cfquery name="rsEmpleadosPrima" datasource="#Session.DSN#">
        select de.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1,de.DEapellido2, ev.EVfantig, ev.EVfecha, ev.EVmes, ev.EVdia, 0
            ,case when  <cf_dbfunction name="datediff" args="#LSParseDateTime(Fdesde)#,ev.EVfantig,dd"> < 0 then 
	      (((((<cf_dbfunction name="date_part" args="yyyy, '#Fdesde#'"> + 0) * 100) + 
            	<cf_dbfunction name="date_part"	 args="mm, ev.EVfantig">) * 100) + 
                <cf_dbfunction name="date_part"	 args="dd, ev.EVfantig">)
          else
				(((((<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> + 1  ) * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
          end as AAntig  
        
<!---         case when  
       		(<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> + <cf_dbfunction name="date_part"	args="mm, ev.EVfantig">)  < 
            (<cf_dbfunction name="date_part"	args="yyyy, '#form.FechaDesde#'"> +  <cf_dbfunction name="date_part"	args="mm, '#form.FechaDesde#'">) then
            
            ((((<cf_dbfunction name="date_part"	args="yyyy, '#form.FechaDesde#'"> * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
        else
         	((((<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
        end as AAntig--->
        <!---case when  
       		(<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> * 100 + <cf_dbfunction name="date_part"	args="mm, ev.EVfantig">)  <=
            (<cf_dbfunction name="date_part"	args="yyyy, '#Fdesde#'">  * 100 +  <cf_dbfunction name="date_part"	args="mm, '#Fdesde#'">) then
            
            (((((<cf_dbfunction name="date_part"	args="yyyy, '#Fdesde#'"> + 1) * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
        else
         	(((((<cf_dbfunction name="date_part"	args="yyyy, ev.EVfantig"> + 0  ) * 100) + 
            	<cf_dbfunction name="date_part"	args="mm, ev.EVfantig">) *100) + 
                <cf_dbfunction name="date_part"	args="dd, ev.EVfantig">)
        end as AAntig--->
        
        from DatosEmpleado de
            inner join EVacacionesEmpleado  ev
                on de.DEid = ev.DEid
<!---           inner join LineaTiempo lt
        on de.DEid = lt.DEid
            and <cfqueryparam cfsqltype="cf_sql_date" value="#Fdesde#">  between lt.LTdesde and lt.LThasta
--->        where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and de.DEid in  (#form.chk#)
    </cfquery>
    
    
   <!--- <cfdump var="#rsEmpleadosPrima#">--->
   
    
     <cfloop query="rsEmpleadosPrima">
		<cfset fecha = createdate(mid(#rsEmpleadosPrima.AAntig#,1,4),mid(#rsEmpleadosPrima.AAntig#,5,2),mid(#rsEmpleadosPrima.AAntig#,7,2))>
        
		<cfquery name="rsInsertPrima" datasource="#Session.DSN#">
        	insert into #PrimaVac# (DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2, EVfantig , EVfecha, EVmes, EVdia,  MontoPrima, FIncidencia, Cantidad)
            values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleadosPrima.DEid#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEidentificacion#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEnombre#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEapellido1#">,
                    <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rsEmpleadosPrima.DEapellido2#">,
                    <cfqueryparam  cfsqltype="cf_sql_date" 	value="#rsEmpleadosPrima.EVfantig#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpleadosPrima.EVfecha#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleadosPrima.EVmes#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleadosPrima.EVdia#">,
                    0,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">,
                    0)
		</cfquery>              
     </cfloop>
    
<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

<cfquery name="rsEmpleadosPrima" datasource="#Session.DSN#">
    select DEid as Chequeado, DEid, DEidentificacion, <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as Empleado, MontoPrima, EVfantig
    from #PrimaVac# 
    order by <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2">
</cfquery>  

<!---   <cfdump var="#rsEmpleadosPrima#"> --->

<cfloop query="rsEmpleadosPrima">
    <cfquery name="rsConcepto" datasource="#session.DSN#">
        select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
            , <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosPrima.DEid#"> as DEid,  0 as MontoIncidencia
        from CIncidentes a
            inner join CIncidentesD b
                on a.CIid = b.CIid
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
    </cfquery>
    
     <!--- <cfdump var="#rsConcepto#"> --->
    
    <cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
        <!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL COMPONENTES --->
        <cfset FVigencia = LSDateFormat(rsEmpleadosPrima.EVfantig, 'DD/MM/YYYY')>
        <cfset FFin = LSDateFormat(now(), 'DD/MM/YYYY')>
        <cfset current_formulas = rsConcepto.CIcalculo>
        <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                       rsConcepto.CIcantidad,
                                       rsConcepto.CIrango,
                                       rsConcepto.CItipo,
                                       rsConcepto.DEid,
                                       0,	<!---RHJid--->
                                       session.Ecodigo,
                                       0,	<!---RHTid--->
                                       0,	<!---RHAlinea--->
                                       rsConcepto.CIdia,
                                       rsConcepto.CImes,
                                       "",	<!---Tcodigo--->
                                       FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mÃ¡s pesado--->
                                       'false',	<!---masivo--->
                                       '',	<!---tablaTemporal--->
                                       FindNoCase('DiasRealesCalculoNomina', current_formulas), <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
                                       0, 	<!---cantidad--->
                                       "", 	<!---origen--->
                                       "",	<!---CIsprango--->
                                       0, 	<!---CIspcantidad--->
                                       0, 	<!---CImescompleto--->
                                       rsConcepto.MontoIncidencia
                                       )>
                                       
                                       
                                       
        <cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
        <cfset calc_error = RH_Calculadora.getCalc_error()>
        <cfif Not IsDefined("values")>
            <cfif isdefined("presets_text")>
                <cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
            <cfelse>
                <cfthrow detail="#calc_error#" >
            </cfif>
        </cfif>
        <cfset vn_cantidad 	= values.get('cantidad').toString()>
        <cfset vn_importe 	= values.get('importe').toString()>
        <cfset vn_resultado = values.get('resultado').toString()>
    <cfelse>
        <cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
    </cfif>
    
  
    <cfif vDebug>
        Cantidad:<cfdump var="#vn_cantidad#"> </br>
        Importe:<cfdump var="#vn_importe#"></br>
        Resultado: <cf_dump var="#vn_resultado#"></br>
    </cfif>
    <cfquery name="rsUpdatePrima" datasource="#Session.DSN#">
        update #PrimaVac# set MontoPrima = #vn_resultado#, Cantidad = #vn_cantidad#  where #PrimaVac#.DEid = #rsEmpleadosPrima.DEid#
    </cfquery>  
</cfloop>

<cfquery name="rsinsert" datasource="#Session.DSN#">
    select *
    from #PrimaVac# 
   	where MontoPrima > 0
    order by <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2">
</cfquery>

<!--- <cf_dump var="#rsinsert#">----->

<cfloop query="rsinsert">
    <cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta" 
    DEid = "#rsinsert.DEid#"
    CIid = "#Form.CIid#"
    iFecha = "#LSParseDateTime(form.FechaDesde)#"
    iValor = "#rsinsert.Cantidad#"	
    Imonto = "#rsinsert.MontoPrima#"	
    Ifechacontrol = "#LSParseDateTime(rsinsert.FIncidencia)#"
    
    returnVariable="Lvar_Iid">
    <cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
        <cfinvokeargument name="CFid" value="#Form.CFid#">
    </cfif>
    <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) gt 0>
        <cfinvokeargument name="RHJid" value="#Form.RHJid#">
    </cfif>
    <cfif isdefined("form.Tnomina") and #form.Tnomina# EQ 1>
        <cfinvokeargument name="Icpespecial" value="1">		
    <cfelse>
        <cfinvokeargument name="Icpespecial" value="0">		
    </cfif>
    </cfinvoke>
</cfloop>

<cflocation url="GenerarPrimas.cfm">










