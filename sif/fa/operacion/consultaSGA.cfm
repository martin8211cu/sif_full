<style type="text/css">
.Titulo {
	font-size: 18px;
}
</style>
     <cfif not isdefined('btnAgregar')>              
                                      
			<cfif isdefined("URL.ETnumero") and len(trim(#url.ETnumero#)) gt 0 >
               <cfset form.ETnumero = URL.ETnumero>
            </cfif>            
            <cfif isdefined("URL.FCid") and len(trim(url.FCid)) gt 0>
               <cfset form.FCid = URL.FCid>
            </cfif>
             <cfif isdefined("URL.FVid") and len(trim(url.FVid)) gt 0>
               <cfset form.FVid = URL.FVid>
            </cfif>
            <cfif isdefined("URL.Dcodigo") and len(trim(#url.Dcodigo#)) gt 0 >
               <cfset form.Dcodigo = URL.Dcodigo>
            </cfif>            
            <cfif isdefined("URL.zona") and len(trim(url.zona)) gt 0>
               <cfset form.zona = URL.zona>
            </cfif>
            <cfif isdefined("URL.SNid") and len(trim(url.SNid)) gt 0>
               <cfset form.SNid = URL.SNid>
            </cfif>
            <cfset navegacion = ''> 
            <cfset ffiltro = 'and 1= 1'> 
            
            <cfif isdefined("url.filtro_estudiante") and len(trim(url.filtro_estudiante)) NEQ 0>
             <cfset form.filtro_estudiante = url.filtro_estudiante>
            </cfif>
            <cfif isdefined("form.filtro_estudiante") and len(trim(form.filtro_estudiante)) NEQ 0>
                <cfset ffiltro = ffiltro & " and upper(b1.UserFullName) like  '%#UCase(Form.filtro_estudiante)#%'">        
                <cfset navegacion = navegacion & "&b1.UserFullName=#trim(form.filtro_estudiante)#">
            </cfif>    
            
            <cfif isdefined("url.filtro_ced") and len(trim(url.filtro_ced)) NEQ 0>
             <cfset form.ced = url.filtro_ced>
            </cfif>
            <cfif isdefined("form.filtro_ced") and len(trim(form.filtro_ced)) NEQ 0>
                 <cfset ffiltro = ffiltro & " and b.Identification =  #Form.filtro_ced#">        
                 <cfset navegacion = navegacion & "&b.Identification=#trim(form.filtro_ced)#">
            </cfif>    
            
            <cfif isdefined("url.filtro_zona") and len(trim(url.filtro_zona)) NEQ 0>
                 <cfset form.filtro_zona = url.filtro_zona>
            </cfif>
            <cfif isdefined("form.filtro_zona") and len(trim(form.filtro_zona)) NEQ 0>
                 <cfset ffiltro = ffiltro & " and upper(h.ZoneName) like  '%#UCase(Form.filtro_zona)#%'">         
                 <cfset navegacion = navegacion & "&h.ZoneName=#trim(form.filtro_zona)#">
            </cfif>    
            
            <cfif isdefined("url.curso") and len(trim(url.curso)) NEQ 0>
                 <cfset form.ced = url.curso>
            </cfif>
            <cfif isdefined("form.filtro_zona") and len(trim(form.filtro_zona)) NEQ 0>
                 <cfset ffiltro = ffiltro & " and upper(h.ZoneName) like  '%#UCase(Form.filtro_zona)#%'">         
                 <cfset navegacion = navegacion & "&h.ZoneName=#trim(form.filtro_zona)#">
            </cfif> 
            
            <cfquery name="rsCajas1" datasource="#session.dsn#">
             select FCid,FCcodigo,FCcodigoAlt,FCdesc from FCajas where Ecodigo = 1  and FCestado = 1
            </cfquery>
          
            <cfquery name="rsCajas2" datasource="#session.dsn#">
             select FCid, FCcodigo,FCcodigoAlt,FCdesc from FCajas where Ecodigo = 1  and FCestado = 1 and FCid = #session.caja#
            </cfquery>
            <cfif not isdefined('form.Caja')>                        
                <cfset form.Caja = rsCajas2.FCcodigoAlt>                          
                <cfset ffiltro = ffiltro & " and g.LocationName = '#Form.Caja#'">         
                <cfset navegacion = navegacion & "&g.LocationName=#trim(form.Caja)#">
            <cfelse>
               <cfif Form.Caja neq -1 and len(trim(Form.Caja)) gt 0>               
                   <cfset ffiltro = ffiltro & " and g.LocationName = '#Form.Caja#'">         
                   <cfset navegacion = navegacion & "&g.LocationName=#trim(form.Caja)#"> 
                </cfif>
            </cfif>  
            <cfquery name="rsDatos" datasource="dbsga" maxrows="2000">
                          select    a.GradeID,
                                    b.Identification as ced,b1.UserFullName as estudiante, <!--- Datos del Estudiante--->
                                    c.GroupCode as grupo, c.GroupTime as horario, c.ClassRoom as aula,  <!---Datos del Grupo--->
                                    coalesce(d.Identification,'-2') as cedProfe, coalesce(d1.UserFullName,'SIN DEFINIR') as profe, <!---Datos del Profesor del Grupo--->
                                    e.LevelCode as nivel,LevelDescription as curso, <!---Datos del Curso --->
                                    g.LocationName as loc, SiteName as sitio, <!---Datos de la ubicación--->
                                    h.ZoneName as zona, <!---Datos de la Zona--->
                                    #form.ETnumero# as ETnumero,
                                    #form.FCid# as FCid,
                                    #form.FVid# as vendor,
                                    #form.Dcodigo# as departamento,
                                    #form.zona# as zona,
                                    #form.SNid# as SNid                                    
                            from Grades a
                                inner join Students b
                                on a.StudentID = b.StudentID
                                    inner join Users b1 <!---Para extraer el nombre del Estudiante--->
                                on b.UserID = b1.UserID
                                inner join Groups c
                                on a.GroupID = c.GroupID
                                    left outer join Professors d
                                on c.ProfessorID = d.ProfessorID
                                left outer join Users d1
                                on d.UserID = d1.UserID <!---Para extraer el nombre del profesor--->
                                inner join Levels e
                                on c.LevelID = e.LevelID
                                inner join Categories f
                                on e.CategoryID = f.CategoryID
                                inner join Locations g
                                on c.LocationID = g.locationID
                                    inner join Zones h
                                on g.ZoneId = h.ZoneId
                                where Receipt = '0'
                                #preservesinglequotes(ffiltro)#               
                                order by zona
                   </cfquery>   
<cfoutput>                   
              <form name="filtroSGA" method="post">
                 <table align="center" width="100%" border="0">
                  <tr>
                      <td colspan="12" align="center">
                          <strong class="Titulo">Lista de Matr&iacute;culas Realizadas pendientes</strong>
                          <input type="hidden" name="FVid" id="FVid" value="#form.FVid#"/>
                          <input type="hidden" name="Dcodigo" id="Dcodigo" value="#form.Dcodigo#"/>
                          <input type="hidden" name="ETnumero" id="ETnumero" value="#form.ETnumero#"/>
                          <input type="hidden" name="FCid" id="FCid" value="#form.FCid#"/>
                          <input type="hidden" name="zona" id="zona" value="#form.zona#"/>
                          <input type="hidden" name="SNid" id="SNid" value="#form.SNid#"/>
                      </td>
                  </tr>
                  <tr>
                      <td colspan="12" align="left">
                         <strong>Caja:</strong><select name="Caja" id="Caja">
                           <option value="-1"> - Todos - </option>
                            <cfloop query="rsCajas1">
                              <option value="#rsCajas1.FCcodigoAlt#" <cfif rsCajas1.FCcodigoAlt EQ #form.Caja#>selected</cfif>>#rsCajas1.FCcodigoAlt#- #rsCajas1.FCdesc#</option>
                            </cfloop>
                          </select>
                      </td>
                  </tr>
                  <tr> 
                      <td>
                      <cfinvoke 
                          component="sif.Componentes.pListas"
                          method="pListaQuery"
                         returnvariable="pListaRHRet">
                            <cfinvokeargument name="query" value="#rsDatos#"/>
                            <cfinvokeargument name="cortes" value="zona"/>
                            <cfinvokeargument name="desplegar" value="ced, estudiante, horario,   profe,  curso, loc, zona"/>
                            <cfinvokeargument name="etiquetas" value="Ced, Estudiante,  Horario,  Profesor,  Curso, Localidad, Zona"/>
                            <cfinvokeargument name="formatos" value="S,S,US,S,S,S,S"/>
                            <cfinvokeargument name="align" value="right,right,right,right,right,right,right"/>
                            <cfinvokeargument name="showLink" value="false"/>
                            <cfinvokeargument name="MaxRows" value="12"/>
                            <cfinvokeargument name="navegacion" value="#navegacion#"/>
                            <cfinvokeargument name="checkboxes" value="S"/>
                            <cfinvokeargument name="ajustar" value="S"/>
                            <cfinvokeargument name="filtrar_automatico" value="true">
                            <cfinvokeargument name="mostrar_filtro" value="true">												
                            <cfinvokeargument name="keys" value="ced,nivel,ETnumero,FCid,vendor,departamento,zona,SNid,GradeID,aula,horario,profe,grupo">
                            <cfinvokeargument name="irA" value="consultaSGA.cfm">
                            <cfinvokeargument name="incluyeForm" value="false"/>
                            <cfinvokeargument name="formName" value="filtroSGA"/>
                            <cfinvokeargument name="usaAjax" value="true">
                            <cfinvokeargument name="conexion" value="dbsga">
                            <cfinvokeargument name="botones" value="Agregar"/>
                            <cfinvokeargument name="showEmptyListMsg" value="true"/>
                        </cfinvoke>	
                      </td>
                  </tr>
                   <iframe name="precios" id="precios" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
                 </table>
            </form> 
 </cfoutput>               
<cfelse>
  	<cfset arr 	   = ListToArray(form.CHK, ',', false)>
	<cfset LvarLen = ArrayLen(arr)>              

    <cfloop index="i" from="1" to="#LvarLen#">
		<cfset LvarCed      = "#ListGetAt(arr[i], 1 ,'|')#">  <!---Cedula estudiante --->	
    	<cfset LvarCurso    = "#ListGetAt(arr[i], 2 ,'|')#">  <!--- Level --->
        <cfset LvarETnumero = "#ListGetAt(arr[i], 3 ,'|')#">  <!--- Factura --->
        <cfset LvarFCid     = "#ListGetAt(arr[i], 4 ,'|')#">  <!--- ID de Caja --->	 
        <cfset LvarFVid     = "#ListGetAt(arr[i], 5 ,'|')#">  <!--- ID de vendedor --->	 
        <cfset LvarDcodigo  = "#ListGetAt(arr[i], 6 ,'|')#">  <!--- Codigo departamento --->	 
        <cfset LvarZona     = "#ListGetAt(arr[i], 7 ,'|')#">  <!--- zona --->
        <cfset LvarSNid     = "#ListGetAt(arr[i], 8 ,'|')#">  <!--- SNid --->	
        <cfset LvarGradeID  = "#ListGetAt(arr[i], 9 ,'|')#">  <!--- ID Matricula  --->
        <cfset LvarAula     = "#ListGetAt(arr[i], 10 ,'|')#"> <!--- Aula  --->
        <cfset LvarHorario  = "#ListGetAt(arr[i], 11 ,'|')#"> <!--- Horario    --->
        <cfset LvarProfe    = "#ListGetAt(arr[i], 12 ,'|')#"> <!--- Profesor  --->
        <cfset LvarGrupo    = "#ListGetAt(arr[i], 13 ,'|')#"> <!--- grupo   --->	 
    
	    <cfquery name="rsCursoDesc" datasource="dbsga">
    	  select LevelDescription as descrip from  Levels where  LevelCode= '#LvarCurso#'
     	</cfquery> 
        <cfquery name="rsZona" datasource="#session.dsn#">
    	  select id_zona from  ZonaVenta where  codigo_zona= '#LvarZona#'
     	</cfquery> 
                          
        <cfquery name="rsConcepto" datasource="#session.dsn#">
          Select Cid from Conceptos where Ccodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCurso#">            
        </cfquery> 
        <cfif isdefined('rsConcepto') and rsConcepto.recordcount eq 0>
           <cfthrow message="No se ha encontrado el concepto para el curso: #LvarCurso#">
        </cfif>
        
         <cfquery name="rsCodigoConcepto" datasource="#session.dsn#">
          Select CFid 
            from FACodigosConceptos 
            where Cid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsConcepto.Cid#">            
            and FCid =   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.caja#">            
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">            
        </cfquery> 
        
        <cfif isdefined('rsCodigoConcepto') and rsCodigoConcepto.recordcount eq 0>
           <cfthrow message="No se ha encontrado el centro funcional para el curso: #LvarCurso#">
        </cfif>      
        
        <!----Busco la informacion de las cuentas para el concepto ------>     
              <cfquery name="rsOcodigo" datasource="#session.dsn#">
                select Ocodigo, CFcuentaingreso 
                from  CFuncional where CFid =  #rsCodigoConcepto.CFid# 
                and Ecodigo = #session.Ecodigo#
              </cfquery>
              <cfif isdefined('rsOcodigo') and rsOcodigo.recordcount gt 0 and len(trim(#rsOcodigo.Ocodigo#)) gt 0>
                 <cfset LvarOcodigo = rsOcodigo.Ocodigo>
              <cfelse>
                <cfthrow message="No se ha podido obtener el Ocodigo del centro funcional."> 
              </cfif>                
          
            <cfquery name="rsCcuentaConcepto" datasource="#session.dsn#">
             Select coalesce(c.Cformato,'-1') as Cformato,Cdescripcion, cuentac   from Conceptos c 
             where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcepto.Cid#"> and Ecodigo = #session.Ecodigo#
            </cfquery>
               <cfset LvarCFformato =  rsCcuentaConcepto.Cformato>
                  <cfif LvarCFformato EQ '-1'>
                            <cfset LvarCFformato =  rsOcodigo.CFcuentaingreso>
                             <cfif LvarCFformato neq '-1'>                                                    
                                    <cfif len(trim(rsCcuentaConcepto.cuentac)) gt 0 or len(trim(rsCcuentaConcepto.Cformato)) gt 0>                                                                  
                                        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
                                        <cfset LvarCFformato = mascara.fnComplementoItem(#session.Ecodigo#, #rsCodigoConcepto.CFid#, #LvarSNid#, "S", "", #rsConcepto.Cid#, "", "")>
                                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                                <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                                                <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                                                <cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                                        </cfinvoke>
                                        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                                            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
                                        </cfif>
                                    <cfelse>
                                        <cfthrow message="Se debe definir un complemento o una Cuenta de Gasto para el concepto #rsCcuentaConcepto.Cdescripcion#. Proceso Cancelado!">
                                    </cfif> 
                             <cfelse>
                                <cfthrow message="Se debe definir la máscara de la cuenta de Ingresos en el Centro Funcional. Proceso Cancelado!">                
                             </cfif>   
                      </cfif>
                     <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                            select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                            from CFinanciera 
                            where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                               and CFformato = '#LvarCFformato#'
                        </cfquery>                              
                        <cfif rsCFinanciera.recordcount eq 0>                  
                            <cfthrow message="No se pudo obtener la Cuenta Financiera con el formato '#LvarCFformato#' del concepto #rsCcuentaConcepto.Cdescripcion#. Proceso Cancelado!">    
                        </cfif>           
                                
            <!-------Busco la informacion de la lsita de precios -------->
            <cfquery name="rsListaP" datasource="#Session.DSN#">
                select LPid
                from EListaPrecios
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsZona.id_zona#"> 
                and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCodigoConcepto.CFid#"> 
            </cfquery>
            
            <cfset lista = "">
            <cfif rsListaP.recordcount gt 0>
                <cfset url.LPid = rsListaP.LPid>
            <cfelse>
                <cfquery name="rsListaPSZ" datasource="#Session.DSN#">
                    select LPid
                    from EListaPrecios
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCodigoConcepto.CFid#"> 
                </cfquery>
                <cfif rsListaPSZ.recordcount gt 0>
                    <cfloop query="rsListaPSZ">
                        <cfif len(trim(lista)) eq 0>
                            <cfset lista = LPid>
                        <cfelse>
                            <cfset lista = lista&','&LPid>    
                        </cfif>		
                    </cfloop>
                    <cfset url.LPid = "#lista#">
                <cfelse>
                    <cfquery name="rsListaDefault" datasource="#Session.DSN#">
                        select coalesce(LPid,0) as LPid 
                        from EListaPrecios
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                          and LPdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    </cfquery>
                    <cfset url.LPid = rsListaDefault.LPid>
                </cfif>
            </cfif>
            
            <cfif isdefined("url.LPid") and len(trim(url.LPid)) eq 0>
                <cfset  url.LPid = -1>
            </cfif>
            <!----Datos del encabezado ----->
          <cfquery name="rsETdatos" datasource="#session.dsn#">
          select Mcodigo , ETtc
              from ETransacciones 
              where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarETnumero#"> 
                    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarFCid#"> 
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
          </cfquery>  
          <cfquery name="rsMoneda" datasource="#Session.DSN#">
            select Miso4217
            from Monedas
            where Mcodigo = #rsETdatos.Mcodigo#
            and Ecodigo =  #session.Ecodigo#
          </cfquery>  
          <!--------Invoco la consulta de precios y descuentos ----------->
         <cfquery name="rsMonedaLoc" datasource="#Session.DSN#">
            select m.Miso4217
            from Empresas e
            inner join Monedas m
            on m.Mcodigo = e.Mcodigo
            and m.Ecodigo = e.Ecodigo
            where e.Ecodigo =  #session.Ecodigo#
        </cfquery>
    
        <cfquery name="rsNombreCDestino" datasource="#Session.DSN#">
            select e.LPid,
            coalesce(d.Cid,0) as codigo, 
            d.DLdescripcion,
            d.DLprecio,
            d.Icodigo, 
            d.DLdescuento,
            d.DLrecargo,
            d.moneda,
            d.DLdescuentoTipo,
            d.DLrecargoTipo,
            coalesce(d.CVidD,0) as CVidD,
            coalesce(d.CVidR,0) as CVidR
            from EListaPrecios e
            inner join DListaPrecios d
            on d.LPid = e.LPid
            and d.Ecodigo = e.Ecodigo
            where 
                e.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.LPid#">
            and e.Ecodigo = #session.Ecodigo#
            and d.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcepto.Cid#">
        </cfquery>            
		<cfif rsNombreCDestino.recordcount eq 0>
            <cfquery name="rsNombreCDestino" datasource="#Session.DSN#">
                select e.LPid,
                coalesce(d.Cid,0) as codigo, 
                d.DLdescripcion,
                d.DLprecio,
                d.Icodigo, 
                d.DLdescuento,
                d.DLrecargo,
                d.moneda,
                d.DLdescuentoTipo,
                d.DLrecargoTipo,
                coalesce(d.CVidD,0) as CVidD,
                coalesce(d.CVidR,0) as CVidR
                from EListaPrecios e
                inner join DListaPrecios d
                on d.LPid = e.LPid
                and d.Ecodigo = e.Ecodigo
                where e.Ecodigo = #session.Ecodigo#
                and e.LPdefault = 1
                and d.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcepto.Cid#">
                and '#LSDateFormat(now())#' between d.DLfechaini and d.DLfechafin
                and d.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcepto.Cid#">
            </cfquery>
        </cfif>  
		<cfif rsNombreCDestino.recordcount gt 0 and rsNombreCDestino.CVidD neq 0>
            <cfquery name="rsDescuento" datasource="#Session.DSN#">
                select e.CVid
                from ECalendarioVentas e
                where e.CVTipo = 'D'
                and e.Ecodigo = #session.Ecodigo#
                and e.CVid = #rsNombreCDestino.CVidD#
                and exists (select 1
                            from DCalendarioVentas d
                            where d.Ecodigo = e.Ecodigo
                            and d.CVid = e.CVid
                            and '#LSDateFormat(now())#' between d.CVfechaini and d.CVfechafin)
            </cfquery>
        </cfif>    
		<cfif rsNombreCDestino.recordcount gt 0 and rsNombreCDestino.CVidR neq 0>
            <cfquery name="rsRecargos" datasource="#Session.DSN#">
                select e.CVid
                from ECalendarioVentas e
                where e.CVTipo = 'R'
                and e.Ecodigo = #session.Ecodigo#
                and e.CVid = #rsNombreCDestino.CVidR#
                and exists (select 1
                            from DCalendarioVentas d
                            where d.Ecodigo = e.Ecodigo
                            and d.CVid = e.CVid
                            and '#LSDateFormat(now())#' between d.CVfechaini and d.CVfechafin)
            </cfquery>
        </cfif>
    
        <cfset tipoC = 0>
		<cfif rsNombreCDestino.recordcount gt 0 and rsNombreCDestino.moneda neq rsMoneda.Miso4217>
           <cfset tipoC = 1>
           <cfif rsMonedaLoc.Miso4217 neq rsNombreCDestino.moneda>
                <cfquery name="rsTCambioArt" datasource="#Session.DSN#">
                    select m.Miso4217, tc.Mcodigo, tc.TCventa
                    from Monedas m
                    inner join Htipocambio tc
                    on  tc.Mcodigo = m.Mcodigo
                    and tc.Ecodigo = m.Ecodigo
                    where m.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
                      and m.Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNombreCDestino.moneda#">
                      and tc.Hfecha <= '#LSdateformat(now())#'
                      and tc.Hfechah > '#LSdateformat(now())#'
                </cfquery>
            <cfelse>
                <cfset rsTCambioArt.TCventa = 1>
            </cfif>
        </cfif>   
	
		<cfif isdefined('rsDescuento') and rsDescuento.recordcount gt 0>
            <cfif rsNombreCDestino.DLdescuentoTipo eq 'P'>
                <cfset rsNombreCDestino.DLdescuento = rsNombreCDestino.DLprecio * (rsNombreCDestino.DLdescuento / 100)>
            </cfif>
            <cfif tipoC neq 0>
                <cfset rsNombreCDestino.DLdescuento = rsNombreCDestino.DLdescuento * (rsTCambioArt.TCventa / rsETdatos.ETtc)>
            </cfif>		
        </cfif>
        
		<cfif isdefined('rsRecargos') and rsRecargos.recordcount gt 0>
            <cfif rsNombreCDestino.DLrecargoTipo eq 'P'> 
                <cfset rsNombreCDestino.DLrecargo = rsNombreCDestino.DLprecio * (rsNombreCDestino.DLrecargo / 100)>	
            </cfif>
            <cfif tipoC neq 0>
                <cfset rsNombreCDestino.DLrecargo = rsNombreCDestino.DLrecargo * (rsTCambioArt.TCventa / rsETdatos.ETtc)>
            </cfif>	
        </cfif>
        <cfif tipoC neq 0>
            <cfset rsNombreCDestino.DLprecio = rsNombreCDestino.DLprecio * (rsTCambioArt.TCventa / rsETdatos.ETtc)>
        </cfif> 
    <!---    <cfdump var="#rsNombreCDestino.DLprecio#">
        <cfdump var="#rsNombreCDestino.DLdescuento#">
        <cfdump var="#rsNombreCDestino.DLrecargo#">
        <cf_dump var="#rsNombreCDestino.DLprecio#">--->
     <cftransaction>   
      <!--------Inserto la linea del curso a detalle de la factura------->                        
           <cfquery name="rsInsert" datasource="#session.dsn#">			 	
			insert DTransacciones (
				FCid, ETnumero, Ecodigo, DTtipo,  Cid, FVid, Dcodigo, 
				DTfecha, DTcant, DTpreciou, DTdeslinea, DTreclinea, DTtotal, DTborrado, 
				DTdescripcion,CFid, Ocodigo,CFcuenta,Ccuenta,Icodigo)
			values
            (#LvarFCid#,
			#LvarETnumero#,
			#session.Ecodigo#,
			'S',
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsConcepto.Cid#"> ,
			#LvarFVid#,
			#LvarDcodigo#,
			#now()#,
			1,
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsNombreCDestino.DLprecio#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsNombreCDestino.DLdescuento#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsNombreCDestino.DLrecargo#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#rsNombreCDestino.DLprecio#">,
			0,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCursoDesc.descrip#">,
			#rsCodigoConcepto.CFid#,
			#rsOcodigo.Ocodigo#,
			#rsCFinanciera.CFcuenta#,
			#rsCFinanciera.Ccuenta#,
			 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNombreCDestino.Icodigo#">
			)
            <cf_dbidentity1 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false">
			</cfquery>
	 <cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false" returnvariable="LvarDid">        
     
     <cfif isdefined('LvarDid') and len(trim(#LvarDid#)) gt 0>
        <cf_dbdatabase table="IE600" datasource="sifinterfaces" returnvariable ="IE600">
        <cfquery name="rsBitacora" datasource="#session.dsn#">
          insert #IE600#
          (
            FechaBitacora,
            ETnumero,
            FCid,
            DTlinea,
            GradeID,
            Ecodigo
          )
          values
          (
           <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#now()#">,
    	   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarETnumero#">,
           <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarFCid#">,            
           <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDid#">,            
           <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGradeID#">,
           <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">                      
          )
        </cfquery>  
        
         <cf_dbdatabase table="Grades" datasource="dbsga" returnvariable ="Grades">   
         <cfquery name="rsUpdate" datasource="#session.dsn#">
          update #Grades# set Receipt = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDid#">
           where GradeID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarGradeID#">
        </cfquery> 
        
         <cfquery name="rsUdate" datasource="#session.dsn#">
                    update ETransacciones set
                        ETimpuesto = 
                            (select sum((c.Iporcentaje / 100.00)*coalesce(b.DTtotal,0.00))			             
                            from DTransacciones b, Impuestos c
                            where b.FCid = ETransacciones.FCid 
                                and b.ETnumero = ETransacciones.ETnumero 
                                and b.DTborrado = 0
                                and b.Icodigo = c.Icodigo),
                         ETtotal = 
                            (select  sum(((1+(c.Iporcentaje / 100.00))*coalesce(b.DTtotal,0.00)))       
                            from DTransacciones b, Impuestos c
                            where b.FCid = ETransacciones.FCid 
                                and b.ETnumero = ETransacciones.ETnumero 
                                and b.DTborrado = 0
                                and b.Icodigo = c.Icodigo)                       
                             -  ETransacciones.ETmontodes 
                    where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarFCid#">
                      and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarETnumero#">
             </cfquery>
             <!----Estos valores deben ser valores fijos y deben de estar creados de esta forma obteniendo el DVid para insertar los valores requeridos-----> 
               <!---LvarProfe
        			LvarAula
                    LvarHorario
                    LvarGrupo--->
			 <cfquery name="DVProfe" datasource="#session.dsn#">             
              select b.DVid 
               from DVdatosVariables a 
                      inner join DVvalores b 
                          on a.DVid = b.DVid 
                where b.DVTcodigoValor = 'FA'
                and a.DVcodigo = 'PF'
             </cfquery> 
			 <cfif isdefined('DVProfe') and len(trim(#DVProfe.DVid#)) gt 0>
                 <cfquery name="rsInsProfe" datasource="#session.dsn#">             
                  insert into DVvalores(DVTcodigoValor,DVid,DVVidTablaVal,DVVidTablaSec,DVVvalor)
                  values('FA',#DVProfe.DVid#,#LvarDid#,0,'#LvarProfe#') 
                 </cfquery> 
             </cfif>             
        	 <cfquery name="DVAula" datasource="#session.dsn#">             
              select b.DVid 
               from DVdatosVariables a 
                      inner join DVvalores b 
                          on a.DVid = b.DVid 
                where b.DVTcodigoValor = 'FA'
                and a.DVcodigo = 'AUL'
             </cfquery> 
     		 <cfif isdefined('DVAula') and len(trim(#DVAula.DVid#)) gt 0>
                 <cfquery name="DV2" datasource="#session.dsn#">             
                  insert into DVvalores(DVTcodigoValor,DVid,DVVidTablaVal,DVVidTablaSec,DVVvalor)
                  values('FA',#DVAula.DVid#,#LvarDid#,0,'#LvarAula#') 
                 </cfquery>             
             </cfif>    
             <cfquery name="DVHorario" datasource="#session.dsn#">             
              select b.DVid 
               from DVdatosVariables a 
                      inner join DVvalores b 
                          on a.DVid = b.DVid 
                where b.DVTcodigoValor = 'FA'
                and a.DVcodigo = 'HOR'
             </cfquery>
  			 <cfif isdefined('DVHorario') and len(trim(#DVHorario.DVid#)) gt 0>
                 <cfquery name="DV2" datasource="#session.dsn#">             
                  insert into DVvalores(DVTcodigoValor,DVid,DVVidTablaVal,DVVidTablaSec,DVVvalor)
                  values('FA',#DVHorario.DVid#,#LvarDid#,0,'#LvarHorario#') 
                 </cfquery>              
             </cfif>
             <cfquery name="DVGrupo" datasource="#session.dsn#">             
              select b.DVid 
               from DVdatosVariables a 
                      inner join DVvalores b 
                          on a.DVid = b.DVid 
                where b.DVTcodigoValor = 'FA'
                and a.DVcodigo = 'GR'
             </cfquery> 
    	  	 <cfif isdefined('DVGrupo') and len(trim(#DVGrupo.DVid#)) gt 0>
                 <cfquery name="DV2" datasource="#session.dsn#">             
                  insert into DVvalores(DVTcodigoValor,DVid,DVVidTablaVal,DVVidTablaSec,DVVvalor)
                  values('FA',#DVGrupo.DVid#,#LvarDid#,0,'#LvarGrupo#') 
                 </cfquery>             
             </cfif>
     <cfelse>
        <cfthrow message="Hubieron errores al insertar el registro en los Detalles de la factura. Proceso Cancelado!">  
     </cfif> 
  <cftransaction action="commit">    
  </cftransaction>

              
                     
</cfloop>         
    <script language="javascript">
	  window.opener.location.reload();	 
	   window.close();
  	  
	</script>          
</cfif>
   
