<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="url.periodo" 		type="integer" 	default="-1">	<!----Periodo--->
<cfparam name="url.mes" 			type="integer"	default="-1">	<!----Mes--->
<cfparam name="url.calendariopago" 	type="numeric" 	default="-1">	<!---Calendario de pago---->
<cfparam name="url.historico" 		type="string" 	default="0">	<!---Son nominas historicas---->
<cfparam name="url.CIidlist" 			type="string" 	default="0">	<!---Son nominas historicas---->
<!----Variables de traduccion---->
<cfinvoke Key="MSG_NoHayDatosParaLosFiltrosSeleccionados" Default="No hay datos para los filtros seleccionados" returnvariable="MSG_NoHayDatosParaLosFiltrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" Default="No se ha definido el formato para la generación del archivo" returnvariable="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfset prefijo = ''>
<cfif isdefined("url.historico") and url.historico EQ 1>
	<cfset prefijo = 'H'>
</cfif>
<!----Verificar si existe calendario de pago---->
<cfquery name="rsExisteCalendario" datasource="#session.DSN#">
	select 1 from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
			and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
			and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
		</cfif>
</cfquery>
 
<!---Se lee Número Patronal para reporte Seguro Social 18 Caracteres
X XXXXXXXXXXX XXX XXX
X = Naturaleza del patrono 
  0 fisico nacional
  1 Juridico
  7 Fisica extrangera
  9 identifica numero patronal actual
XXXXXXXXXXX = Numero de cedula

XXX = Segregacion planilla
XXX = Sectorizacio
 --->

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="300" default="" returnvariable="lVarNumPatronal"/>

<cfif len(trim(lVarNumPatronal)) EQ 18>
  <cfset lVarSegregacion = mid(lVarNumPatronal,13,3)>
  <cfset lVarSector = mid(lVarNumPatronal,16,3)>
  
  <cf_dbtemp name="rh_salida_SICERE" returnvariable="Data">
    <cf_dbtempcol name="DEid"    	  type="numeric" mandatory="no">
    <cf_dbtempcol name="tipo" 		  type="char(25)" mandatory="no" >
    <cf_dbtempcol name="cedula" 	  type="char(25)" mandatory="no" >
    <cf_dbtempcol name="clase" 		  type="char(25)" mandatory="no" >
    <cf_dbtempcol name="monto" 		  type="char(25)" mandatory="no" >
    <cf_dbtempcol name="MesAfectar" type="date" mandatory="no" >
  </cf_dbtemp>
    
   

  <!--- 20150203 ljimenez se crean las fechas para el rango que calcula el salario escolar --->
  <cfset Fdesde = createDate(#url.periodo#-1, '01', '01')>
  <cfset Fhasta = createDate(#url.periodo#-1, '12', '31')>



      
  <cfquery datasource="#session.DSN#" name="rs">
       
    insert into  #Data# (DEid,tipo,cedula,clase,monto,MesAfectar)
    select de.DEid,
        case when Ppais != 'CR' then '7' else '0' end as tipo, ltrim(rtrim(de.DESeguroSocial)) as cedula,
     
        'C' as clase, <!---20140130 ljimenez se actualizan todos en clase de seguro C posteriormente se hacen lo update para los pensionados y para las cargas de magisterio--->
        round((select coalesce(sum(hic.ICmontores),0)
               from HIncidenciasCalculo hic
                  inner join CalendarioPagos cp
                      on hic.RCNid=cp.CPid
                   inner join CIncidentes ci
                   	on hic.CIid=ci.CIid
                where cp.CPperiodo = #url.periodo#
                  and cp.CPmes = #url.Mes#
                  and cp.Ecodigo = #session.Ecodigo#
                  and hic.DEid = de.DEid
                  <!---and ci.CInocargasley = 0--->
                  and hic.CIid  in (#url.CIidlist#)
             ),2) as monto

        , (Select Max(LThasta)
        	 from LineaTiempo a
           Where a.DEid=de.DEid
        	) as LThasta               
    from DatosEmpleado de
    where de.DEid in (select DEid
                     from HSalarioEmpleado hpe
                        inner join CalendarioPagos cp
                            on hpe.RCNid=cp.CPid
                      where cp.CPperiodo = #url.periodo#
                      and cp.CPmes=#url.Mes#
                      and Ecodigo = #session.Ecodigo#
                        )
      and (select coalesce(sum(hic.ICmontores),0)
               from HIncidenciasCalculo hic
                  inner join CalendarioPagos cp
                      on hic.RCNid=cp.CPid
                   inner join CIncidentes ci
                    on hic.CIid=ci.CIid
                where cp.CPperiodo = #url.periodo#
                  and cp.CPmes = #url.Mes#
                  and cp.Ecodigo = #session.Ecodigo#
                  and hic.DEid = de.DEid
                  <!---and ci.CInocargasley = 0--->
                  and hic.CIid  in (#url.CIidlist#)
            ) > 0
  </cfquery>

  <cfquery datasource="#session.DSN#" name="rs">
  	update #Data#
      set MesAfectar = (Select Max(LThasta)
      				  From LineaTiempoR ltr
                        Where #Data#.DEid= ltr.DEid)
  	Where exists (Select 1
     				  From LineaTiempoR ltr
                    Where #Data#.DEid= ltr.DEid    			                      
  				  having #Data#.MesAfectar < Max(ltr.LThasta))
  </cfquery>



  <!--- Se aclara que la fecha del mes a afectar debe corresponder a 01/12/2014 para los
  trabajadores activos en enero 2015 o que salieron en diciembre de 2014. Para los demás, 
  el mes debe ser el último mes laborado para el patrono (Por ejemplo: 01/07/2014 para 
  un trabajador que se excluyó cualquier día de julio 2014). Si salió el 01/07/2014 quiere 
  decir que no devengó salario en julio, por lo que la fecha sería 01/06/2014. --->



<cfquery datasource="#Session.DSN#">
    update #Data#   set MesAfectar = case when MesAfectar >= <cf_dbfunction name="to_date"   args="#Fhasta#" >  then
                                        <cf_dbfunction name="to_date"   args="#createDate(url.periodo-1, 12, 1)#" >
                                      else
                                         case
                                           <cfloop from="1" to="12" index="i">
                                              when  month(MesAfectar) = #i# then <cf_dbfunction name="to_date"   args="#createDate(url.periodo-1,i,1)#" >
                                           </cfloop>
                                         end 
                                      end
</cfquery>


  <!--- <cf_dump select = "select * from #Data# order by MesAfectar"> --->

  <!---ljimenez inicio actualiza el tipo de seguro con el valor de parametros RH tab OTROS Carga para Magisterio ---> 
  <!---se actauliza  la case de seguro para los emplados pensionados--->

<!---<cfquery datasource="#Session.DSN#">
    update #Data#
    set clase = 'A'
    where exists(
        select 1
        from DLaboralesEmpleado d
        inner join  RHTipoAccion t 
            on d.RHTid = t.RHTid
            and RHTpension = 1
            and RHTcomportam = 1			
        where d.DEid = #Data#.DEid)
</cfquery> --->

  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2043" default="" returnvariable="vCMagisterio"/>
  <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2044" default="" returnvariable="vIndRep"/>

  <!---se actauliza  la case de seguro para los empleados con cargas al del Magisterio ITCR--->
  <cfif len(rtrim(ltrim(#vCMagisterio#)))  GT 0 >
      <cfquery datasource="#Session.DSN#">
          update #Data#
          set clase = '#vIndRep#'
          where #Data#.DEid = (select DEid
                                from CargasEmpleado
                                where DEid = #Data#.DEid
                                and CEhasta is null
                                and	DClinea = (select convert(numeric, Pvalor)
                                    from RHParametros
                                        where Pcodigo in (2043) and Ecodigo = #session.Ecodigo#))
      
      </cfquery>
      
      
      <!--- ITCR no borrar --->
    <!---<cfquery datasource="#Session.DSN#" name="rsReparto">
        update #Data#
            set clase = '#vIndRep#'
            where #Data#.DEid in ( select distinct DEid 
                                        from DeduccionesEmpleado b
                                        where b.TDid = 123)
    </cfquery>--->
  </cfif>

  <cfquery name="ERR"  datasource="#session.DSN#">
  	select  
      	ltrim(rtrim(tipo)) #_cat# ',' #_cat#  
          ltrim(rtrim(cedula)) #_cat# ',' #_cat#  
          ltrim(rtrim(clase)) #_cat# ',' #_cat#  
         <!--- <cf_dbfunction name="date_format"  args="MesAfectar,DD/MM/YYYY"> #_cat# ',' #_cat#  --->
          ltrim(rtrim(monto))
          #_cat# ',' #_cat# '01' <!---corresponde al mes de enero que es cuando se factura el salario escolar--->
          #_cat# ',' #_cat# '#lVarSegregacion#'
          #_cat# ',' #_cat# '#lVarSector#'
      from #Data#
      order by  tipo,cedula,clase, monto
  </cfquery> 
<cfelse>
    <cfquery name="ERR"  datasource="#session.DSN#">
    select  'Error Número Patronal debe ser 18 Caracteres'
      from dual
  </cfquery> 
</cfif>
   