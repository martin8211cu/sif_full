<cf_templatecss>
	<cf_htmlReportsHeaders
		irA="resultadoencuesta.cfm"
		FileName="Evaluacion.xls"
		title="evalCuestionario">
        
<cf_dbtemp name="DetEncuestas" returnvariable="DetEncuestas" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="DEid" 		 	 		type="numeric"  	mandatory="yes">
    <cf_dbtempcol name="PCUreferencia" 		 	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="PPid" 		 			type="numeric"  	mandatory="yes">    
	<cf_dbtempcol name="PPparte" 		 		type="numeric"  	mandatory="yes">
    <cf_dbtempcol name="PPorden" 	    		type="numeric"  	mandatory="no">    
	<cf_dbtempcol name="PPnumero" 	    		type="numeric"  	mandatory="no">    
	<cf_dbtempcol name="RespSelect" 	    		type="numeric"  	mandatory="no">
	<cf_dbtempcol name="RespExist"  			type="numeric"  	mandatory="no">     
</cf_dbtemp>

<cf_dbtemp name="ResEncuestas" returnvariable="ResEncuestas" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
    <cf_dbtempcol name="PCUreferencia" 		 	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="PPid" 		 			type="numeric"  	mandatory="yes">    
	<cf_dbtempcol name="PPparte" 		 		type="numeric"  	mandatory="yes">
    <cf_dbtempcol name="PPorden" 	    		type="numeric"  	mandatory="no">    
	<cf_dbtempcol name="PPnumero" 	    		type="numeric"  	mandatory="no">    
	<cf_dbtempcol name="RespSelect" 	    	type="numeric"  	mandatory="no">  
    <cf_dbtempcol name="CantResp"  			    type="numeric"  	mandatory="no">   
</cf_dbtemp>

<cfif isdefined('Form.Radio1') and len(Form.Radio1)>
	<cfset OpcionForm=Form.Radio1>
<cfelse >
	<cfset OpcionForm=3>
</cfif>

<cfquery name="nam" datasource="#session.dsn#">
		select RHEEdescripcion from RHEEvaluacionDes where RHEEid=#form.RHEEid#
</cfquery>

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td>
        <cfinvoke key="Cuestionario" default="<b>Cuestionario</b>" returnvariable="LB_Cuestionario" component="sif.Componentes.Translate"  method="Translate"/>
        <cfinvoke key="LB_Empleado" default="<b>Colaborador</b>" returnvariable="LB_Empleado" component="sif.Componentes.Translate"  method="Translate"/>
        <cfset filtro1 = LB_Cuestionario&': #nam.RHEEdescripcion#'>
<!---        <cfset filtro2 = LB_Empleado&':  #ucase(Form.DEidentificacion)# - #Form.NombreEmp#'>--->
            <cf_EncReporte
            Titulo="Resultados Resumidos de Encuestas"
            Color="##E3EDEF"
            filtro1="#filtro1#"
            filtro2=""
            Cols= 11>
    </td>
</tr>
</table>


<cffunction name="RespVariables">
	<cfquery  datasource="#session.dsn#">
        Insert into #ResEncuestas#(PCUreferencia, PPid, PPparte, PPorden, PPnumero, RespSelect, CantResp)
        Select  a.PCUreferencia, b.PPid, bb.PPparte, bb.PPorden, bb.PPnumero, 
               cc.PRid as RespSelect,  count(distinct a.DEid) as CantResp
        from PortalCuestionarioU a
            inner join PortalPreguntaU b
                inner join PortalPregunta bb
                    on b.PPid=bb.PPid
                on a.PCUid=b.PCUid
             inner join PortalRespuestaU c
                inner join PortalRespuesta cc
                    on c.PRid=cc.PRid
                on a.PCUid=c.PCUid
        Where b.PPid=c.PPid
        and a.PCUreferencia=#form.RHEEid#
        and a.PCUid in (Select Max(PCUid)
                             from PortalCuestionarioU
                             Where PCUreferencia=a.PCUreferencia
                             and DEideval=a.DEideval
		                     and DEid=a.DEid
                             group by DEideval)         
        group by a.PCUreferencia, bb.PPparte, bb.PPorden, bb.PPnumero, b.PPid, cc.PRid 
	</cfquery>
 
    <cfquery name="RespResumidas" datasource="#session.dsn#">
    	Select   a.PPparte, a.PPnumero, a.PPid, d.PPpregunta, e.PRtexto, a.CantResp
        from #ResEncuestas# a
            inner join PortalPregunta d
             	on a.PPid=d.PPid
            inner join PortalRespuesta e
                on a.RespSelect=e.PRid
                and a.PPid=e.PPid
        Order by a.PCUreferencia, a.PPparte, a.PPorden, a.PPnumero, a.PPid,a.RespSelect
    </cfquery>
   
	 	<cfoutput>	     
            <table class="reporte" width="99%" align="center" > 
            <tr><td colspan="3"  align="center"><font class="subtitulo" >Preguntas de Respuesta Variable </font></td></tr>
            <tr>
                <td width="50%" >
                    <B>Preguntas</B>
                </td>
                <td width="50%" align="center">
                    <B>Respuesta Seleccionada</B>
                </td>
                 <td width="50%" align="center">
                    <B>Cantidad de Respuestas Similares</B>
                </td>
            </tr>
        	 </cfoutput>	 
            <cfset cont = 0>
	            <cfoutput query="RespResumidas">
                	<cfquery  name="CantResp" datasource="#session.dsn#">
                    	Select   count(a.CantResp) as cantidad
        				from #ResEncuestas# a
                        Where a.PPid=#PPid#
                    </cfquery>
                    
                        <tr  >      
                            <cfif cont eq 0>                       
                            <td rowspan="#CantResp.Cantidad#" width="53%" valign="middle" >#RespResumidas.PPnumero# &nbsp; #RespResumidas.PPpregunta#</td>
                            </cfif>
                            <td width="23%" valign="middle" align="center">#RespResumidas.PRtexto#</td>                
                            <td width="22%" valign="middle" align="center">#RespResumidas.CantResp#</td>    
                        </tr>
                         <cfset cont += 1> 
                         
                         <cfif cont eq CantResp.Cantidad>
                         	<cfset cont =0> 
                         </cfif>
                            
	            </cfoutput>
	    </table> 		
</cffunction>

<!---<!--- Esta salida finalmente no se pintó, para mantener anonimo los resultados de una encuesta --->
<cffunction name="DetaRespVariables">
  <cfquery  datasource="#session.dsn#">
        Insert into #DetEncuestas#(DEid, PCUreferencia, PPid, PPparte, PPorden, PPnumero, RespSelect, RespExist)
        Select a.DEid, a.PCUreferencia, b.PPid, bb.PPparte, bb.PPorden, bb.PPnumero, 
               cc.PRid as RespSelect,null
        from PortalCuestionarioU a
            inner join PortalPreguntaU b
                inner join PortalPregunta bb
                    on b.PPid=bb.PPid
                on a.PCUid=b.PCUid
             inner join PortalRespuestaU c
                inner join PortalRespuesta cc
                    on c.PRid=cc.PRid
                on a.PCUid=c.PCUid
        Where b.PPid=c.PPid
        and a.PCUreferencia=#form.RHEEid#
        and a.PCUid in (Select Max(PCUid)
                             from PortalCuestionarioU
                             Where PCUreferencia=a.PCUreferencia
                             and DEideval=a.DEideval
		                     and DEid=a.DEid
                             group by DEideval)  
    </cfquery>
    <cfquery  name="DetalleEncuestas" datasource="#session.dsn#">
    	Select  f.DEid, f.DEidentificacion, f.DEnombre, f.DEapellido1, f.DEapellido2,  
        		a.PPnumero, a.PPid, d.PPpregunta, a.RespSelect, a.RespExist, e.PRtexto
        from #DetEncuestas# a
            inner join PortalPregunta d
             	on a.PPid=d.PPid
            inner join PortalRespuesta e
                on a.RespSelect=e.PRid
                and a.PPid=e.PPid
            inner join DatosEmpleado f
            	on f.DEid=a.DEid
         <cfif isdefined('form.DEid') and len(form.DEid)>
         	Where a.DEid = #form.DEid#
         </cfif>
        Order by a.PPparte, a.PPorden, a.PPnumero,a.PPid, a.DEid, a.PCUreferencia,  a.RespSelect
    </cfquery>
  <table class="reporte" width="99%" align="center" border="1" cellspacing="0" cellpadding="0">
		   <cfset cont = 0>
           <!---<cf_dump var="#DetalleEncuestas#">--->
            <cfoutput query="DetalleEncuestas">
                    <tr valign="middle" >      
                            <cfif isdefined('Form.DEid') and len(Form.DEid)>
                                    <cfquery  name="CantResp" datasource="#session.dsn#">
                                        Select   count(a.PPid) as cantidad
                                        from #DetEncuestas# a
                                        Where a.PPid=#PPid#
                                        and DEid=#DEid#
                                    </cfquery>
                               
                                  <cfif cont eq 0>
                                    <td rowspan="#CantResp.Cantidad#" width="50%">#DetalleEncuestas.PPnumero# &nbsp; #DetalleEncuestas.PPpregunta#</td>
                                  </cfif>
                                    <td width="50%" valign="middle" align="center">#DetalleEncuestas.PRtexto#</td>                
    
                            <cfelse>
                                   <cfquery  name="CantResp" datasource="#session.dsn#">
                                        Select   count(a.PPid) as cantidad
                                        from #DetEncuestas# a
                                        Where a.PPid=#PPid#
                                    </cfquery>
                               
                                  <cfif cont eq 0>
                                    <td rowspan="#CantResp.Cantidad#" width="50%"  >#DetalleEncuestas.PPnumero# &nbsp; #DetalleEncuestas.PPpregunta#</td>
                                  </cfif>
                                  <!---  <td width="25%" valign="middle" align="left">#DetalleEncuestas.DEidentificacion# &nbsp; 
                                                                                      #DetalleEncuestas.DEnombre# &nbsp;  
                                                                                      #DetalleEncuestas.DEapellido1# &nbsp;  
                                                                                      #DetalleEncuestas.DEapellido2#</td>  --->
                                    <td width="50%" valign="middle" align="center">#DetalleEncuestas.PRtexto#</td>                
                             </cfif>
                    </tr>
                     <cfset cont += 1> 
                     <cfif cont eq CantResp.Cantidad>
                        <cfset cont =0> 
                     </cfif>
                        
            </cfoutput>
     </table>
</cffunction>
--->
<cffunction name="RespObservaciones">
 	<cfquery  datasource="#session.dsn#" name="RespAbiertas">
        Select a.DEid, a.PCUreferencia, b.PPid, bb.PPparte, bb.PPorden, bb.PPnumero, b.PCUtexto , bb.PPpregunta, c.DEidentificacion, c.DEapellido1, c.DEapellido2, c.DEnombre
        from PortalCuestionarioU a
            inner join PortalPreguntaU b
                inner join PortalPregunta bb
                    on b.PPid=bb.PPid
                    and b.PCUtexto is not null
                on a.PCUid=b.PCUid
            inner join DatosEmpleado c
            	on a.DEid=c.DEid
        Where a.PCUreferencia=#form.RHEEid#
        and a.PCUid in (Select Max(PCUid)
                             from PortalCuestionarioU
                             Where PCUreferencia=a.PCUreferencia
                             and DEideval=a.DEideval
		                     and DEid=a.DEid
                             group by DEideval)  
        
        <cfif isdefined('form.DEid') and len(form.DEid)>
         	and a.DEid = #form.DEid#
         </cfif>
        Order by bb.PPparte, bb.PPorden, bb.PPnumero,b.PPid, a.DEid, a.PCUreferencia
    </cfquery>
    <table class="reporte" width="99%" align="center">
    <tr >
        <td colspan="3"  align="center">
            <font class="subtitulo" >Preguntas de Respuesta Abierta</font>
        </td>
    </tr>
    
       <cfset cont = 0>
		<cfoutput query="RespAbiertas">
                <tr >      
						<cfif isdefined('Form.DEid') and len(Form.DEid)>
                                <cfquery dbtype="query"  name="CantResp" >
                                    Select   count(PPid) as cantidad
                                    from RespAbiertas 
                                    Where PPid=#PPid#
                                    and DEid=#DEid#
                                </cfquery>
                           
                        	  <cfif cont eq 0>
                                <td rowspan="#CantResp.Cantidad#" width="50%"  >#RespAbiertas.PPnumero# &nbsp; #RespAbiertas.PPpregunta#</td>
                              </cfif>
                                <td width="50%" valign="middle" align="center">#RespAbiertas.PCUtexto#</td>                

                        <cfelse>
    							 <cfquery dbtype="query"  name="CantResp" >
                                    Select   count(PPid) as cantidad
                                    from RespAbiertas 
                                    Where PPid=#PPid#
                                </cfquery>
                           
							  <cfif cont eq 0>
                                <td rowspan="#CantResp.Cantidad#" width="50%"  >#RespAbiertas.PPnumero# &nbsp; #RespAbiertas.PPpregunta#</td>
                              </cfif>
                                <td width="50%" valign="middle" align="justify">#RespAbiertas.PCUtexto#</td>                
                  		 </cfif>
                </tr>
                 <cfset cont += 1> 
                 <cfif cont eq CantResp.Cantidad>
                    <cfset cont =0> 
                 </cfif>
        </cfoutput>
     </table>
</cffunction>

<cfif OpcionForm eq 0><!--- Todo --->
	 <cfset resultado=RespVariables()>
	 <cfset resultado=RespObservaciones()>     
<cfelseif OpcionForm eq 1 > <!--- Respuestas Variables --->
	 <cfset resultado=RespVariables()>
<cfelseif OpcionForm eq 2 > <!--- Respuestas Abiertas --->	
	 <cfset resultado=RespObservaciones()>     
</cfif>


