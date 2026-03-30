<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfset Param = "">
<cf_templatecss>
<style type="text/css">
.TituloPrinc {
	font-size: 24px;
	font-weight: bold;
}
</style>

<cfif isdefined('url.indice') and len(trim(url.indice)) gt 0>    
     <cfset Param = Param & "&indice="&url.indice>

    <cfset MaxLineas = 20>  
     <cfset contador = 0>   
    <cfset arr 	   = ListToArray(url.indice, ',', false)>
    <cfset LvarLen = ArrayLen(arr)>
    <cf_rhimprime datos="/sif/cm/catalogos/imprimirContrato.cfm" paramsuri="#Param#">                   
       <cfquery name="rsEContrato" datasource="#session.dsn#">
         Select 
                a.Consecutivo,
                a.ECid, 
                a.SNcodigo, 
                a.ECaviso, 
                a.CMIid, 
                a.ECtiempoentrega, 		  
                a.Usucodigo, 
                b.SNnumero, 
                b.SNnombre, 
                case when ECestado = 1 then 'Activo'
                else 
                'Inactivo'
                end as ECestado,
                a.ECdesc, 
                a.ECfechaini, 
                a.ECfechafin,
                a.ECfalta, 
                ltrim(rtrim(a.CMTOcodigo)) as CMTOcodigo, 
                a.Rcodigo, 
                a.ECplazocredito, 
                a.ECporcanticipo, 
                a.CMFPid, 
                a.ts_rversion
		from EContratosCM a
			inner join SNegocios b
				on a.Ecodigo = b.Ecodigo
  		   		and a.SNcodigo = b.SNcodigo
			left outer join DContratosCM c
				on a.ECid = c.ECid
					and a.Ecodigo = c.Ecodigo	
				
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
  		  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Indice#">
       </cfquery>                
           
<table border="0" cellpadding="0" align="center" cellspacing="0" width="100%">       
          <tr>
            <td colspan="2" align="center"><strong class="TituloPrinc">Reporte de Contratos</strong></td>            
          </tr>
          <tr>
            <td colspan="2" align="center">&nbsp;</td>            
          </tr>
           <tr>
            <td colspan="2" align="left"><strong>Descripci&oacute;n:</strong>&nbsp;&nbsp;<cfoutput>#rsEContrato.ECdesc#</cfoutput></td>           
          </tr>
          <tr>
             <td><strong>Contrato:</strong>&nbsp;&nbsp;<cfoutput>#rsEContrato.Consecutivo#</cfoutput></td>
            <td><strong>Fecha de Elaboración:</strong>&nbsp;&nbsp;<cfoutput>#DateFormat(rsEContrato.ECfalta,'dd-mm-yyyy')#</cfoutput></td>                       
          </tr>
          <tr>
            <td><strong>Proveedor:</strong>&nbsp;&nbsp;<cfoutput>#rsEContrato.SNnumero#-#rsEContrato.SNnombre#</cfoutput></td>      
            <td><strong>Fecha Vencimiento:</strong>&nbsp;&nbsp;<cfoutput>#DateFormat(rsEContrato.ECfechafin,'dd-mm-yyyy')#</cfoutput></td>      
          </tr>
          <tr>
            <td><strong>Fecha Inicio:</strong>&nbsp;&nbsp;<cfoutput>#DateFormat(rsEContrato.ECfechaini,'dd-mm-yyyy')#</cfoutput></td>            
            <td><strong>Estado:</strong>&nbsp;&nbsp;<cfoutput>#rsEContrato.ECestado#</cfoutput></td>            
          </tr>          
          <tr>
            <td colspan="2"> 
            <hr />
            </td>            
           
          </tr>       
       </table>
       
       <cfquery name="rsDCLineas" datasource="#session.dsn#">
         select 
            DCtipoitem,
            Aid,
            Cid,
            ACcodigo,
            ACid,Ucodigo,
          #LvarOBJ_PrecioU.enSQL_AS("DCpreciou")#, 
           (Select Miso4217 from Monedas m where m.Mcodigo =  a.Mcodigo and m.Ecodigo = a.Ecodigo)as Mcodigo,
           DCtc,
           DCgarantia,
           DCdescripcion,
           DCdescalterna, 
          case when DCtipoitem = 'S' then
           1 
           else 
           DCcantcontrato
           end 
           as DCcantcontrato,
          DCcantsurtida, Ucodigo, ts_rversion, Icodigo, coalesce(DCdiasEntrega,0) as DCdiasEntrega
		from DContratosCM a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and ECid = <cfqueryparam value="#Indice#" cfsqltype="cf_sql_numeric">
       </cfquery>
       
        <table border="0" cellpadding="0" cellspacing="0" width="100%">  
         <tr>
              <td align="center"><strong>Tipo</strong></td> 
              <td align="center"><strong>Art&iacute;culo</strong></td>
               <td align="center"><strong>U. Medida</strong></td>              
              <td align="center"><strong>Cantidad</strong></td>              
              <td align="center"><strong>Precio</strong></td>
              <td align="center"><strong>Moneda</strong></td>
              <td align="center"><strong>D&iacute;as Entrega</strong></td>          
         </tr>
         <cfif rsDCLineas.recordcount gt 0>  
             <cfloop query="rsDCLineas">
              <tr>
                <td align="center"><cfoutput>#rsDCLineas.DCtipoitem#</cfoutput>
                  </td>
                  <td align="center"><cfoutput>#rsDCLineas.DCdescripcion#</cfoutput>
                  </td>
                  <td align="center"><cfoutput>#rsDCLineas.Ucodigo#</cfoutput>
                  </td>              
                  <td align="center"><cfoutput>#rsDCLineas.DCcantcontrato#</cfoutput>
                  </td>                                  
                  <td align="right"><cfoutput>#rsDCLineas.DCpreciou#</cfoutput>
                  </td>
                  <td align="center"><cfoutput>#rsDCLineas.Mcodigo#</cfoutput>
                  </td>
                  <td align="center"><cfoutput>#rsDCLineas.DCdiasEntrega#</cfoutput>
                  </td>
              </tr>
              <cfif contador eq MaxLineas and isdefined('url.imprimir')>     
                 </table>
                  <BR style="page-break-after:always;">   
                 <table border="0" cellpadding="0" cellspacing="0" width="100%">    
                 <tr>
                      <td align="center"><strong>Tipo</strong></td> 
                      <td align="center"><strong>Art&iacute;culo</strong></td>
                       <td align="center"><strong>U. Medida</strong></td>              
                      <td align="center"><strong>Cantidad</strong></td>              
                      <td align="center"><strong>Precio</strong></td>
                      <td align="center"><strong>Moneda</strong></td>
                      <td align="center"><strong>D&iacute;as Entrega</strong></td>          
                 </tr>
                 <cfset contador = 0>    
              </cfif>
              <cfset contador = contador + 1 >
             </cfloop>
         <cfelse>
              <tr>
                  <td colspan="7" align="center">
                   ---------- No existen líneas de detalle -----------
                  </td>
              </tr>
         </cfif>
        </table>             
  <BR style="page-break-after:always;">        
     
	
<cfelse>
 <cfthrow message="No se ha definido ninguna factura para mostrar su información!">
  <script language="javascript">
   window.close();
  </script>
</cfif>
