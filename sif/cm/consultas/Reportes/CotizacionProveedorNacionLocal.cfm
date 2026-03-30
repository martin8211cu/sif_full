<cfparam name="LvarTitle" 		default="COTIZACION DE MATERIALES">
<cfparam name="LvarXproveedor"  default="TRUE">
<cfparam name="LvarPrint" 		default="FALSE">
<style type="text/css">
	
.TituloPrincipal {
	font-size: 21px;
	font-weight: bold;
}
.LetraTitulo{
	font-size: 13px;
	font-weight: bold;

	}
.NumeroProceso{
	font-size: 16px;
	font-weight: bold;

	}
.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
.LetraInfo{
		font-size:11px;
	}			
</style>
<cfquery name="Empresa" datasource="asp">
		select Efax, Etelefono1,ts_rversion from Empresa where Ecodigo = #session.Ecodigo#
</cfquery>
<!---►►Hace Corte para cada uno de los provedores◄◄--->
<cfif LvarXproveedor>
<table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">
   <cfset contador = 1> 
   <cfset LvarSocio = ''>
   <cfset max_lineas = 10> 
       
			<!--- Primer Loop para pintar las líneas de solicitud --->
			 <cfloop query="rs">
               
               <cfquery name="Comprador" datasource="#session.dsn#">
                    select  coalesce(Pemail1, Pemail2 ) as correo, coalesce(Poficina, coalesce(Pcelular,Pcasa)) as telefono, Pfax as fax 
                    from DatosPersonales d 
                    	inner join Usuario u 
                      		on u.datos_personales = d.datos_personales
                    where u.Usucodigo = #rs.Usucodigo#
                </cfquery>

				<cfif #rs.SNcodigo# neq LvarSocio>   
                     <cfif len(trim(LvarSocio)) gt 0>                         
						 </table> 
                          <BR style="page-break-after:always;">  
                         <table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">                      
                     </cfif>
					<tr>
                        <td colspan="9">
						 <cfoutput>
                          <table align="center" width="100%" border="0" cellpadding="0" cellspacing="3">
                               <cfset Printheader()>
                                <tr>
                                    <td width="6%" align="left" class="LetraTitulo">Proveedor:</td>
                                    <td colspan="2" align="left" class="LetraInfo"><cfoutput>#rs.SNcodigo# - #rs.SNnombre#</cfoutput></td>
                                    <td></td>
                                    <td class="LetraTitulo">Fecha Emisión:</td>
                                    <td class="LetraInfo"><cfoutput>#dateformat(rs.CMPfechapublica,'dd/mm/yyyy')#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Direcci&oacute;n:</td>
                                    <td colspan="2" class="LetraInfo" ><cfoutput>#rs.SNdireccion#</cfoutput></td>
                                    <td></td>
                                    <td class="LetraTitulo">&nbsp;</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Tel&eacute;fono:</td>
                                    <td class="LetraInfo" width="28%"><cfoutput>#rs.SNtelefono#</cfoutput> 
                                                </td>
                                    <td width="7%" class="LetraTitulo" align="right">Fax:</td>
                                    <td class="LetraInfo"><cfoutput>#rs.SNFax#</cfoutput></td>
                                    <td class="LetraTitulo">Moneda:</td>
                                    <td class="LetraInfo"></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">&nbsp;</td>
                                    <td colspan="2"></td>
                                    <td></td>
                                    <td class="LetraTitulo">Forma de Pago:</td>
                                    <td class="LetraInfo"><cfoutput>#rs.CMFPdescripcion#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Comprador:</td>
                                    <td colspan="2" class="LetraInfo"><cfoutput>#rs.CMCnombre#</cfoutput></td>
                                    <td></td>
                                    <td class="LetraTitulo">&nbsp;</td>
                                    <td class="LetraInfo">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Correo:</td>
                                    <td colspan="2" class="LetraInfo"><cfoutput>#Comprador.correo#</cfoutput></td>
                                    <td></td>
                                    <td><span class="LetraTitulo">Fecha Límite:</span></td>
                                    <td><span class="LetraInfo"><cfoutput>#dateformat(rs.CMPfmaxofertas,'dd/mm/yyyy')#</cfoutput></span></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Tel&eacute;fono:</td>
                                    <td class="LetraInfo"><cfoutput>#Comprador.telefono#</cfoutput></td>
                                    <td width="7%" class="LetraTitulo" align="right">Fax:</td>
                                    <td class="LetraInfo"><cfoutput>#Comprador.fax#</cfoutput></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                       </table>  
						 </cfoutput>
					    </td>
                    </tr>
                    <cfset PrintLineasHeader()>    
               </cfif>  
				<cfset PrintLineas()>		
                <cfset LvarSocio = rs.SNcodigo>
                <cfset contador=  contador + 1>	                              
           </cfloop> 
	</table>
<cfelse> 
	<cfoutput>
        <cfquery name="Comprador" datasource="#session.dsn#">
            select  coalesce(Pemail1, Pemail2 ) as correo, coalesce(Poficina, coalesce(Pcelular,Pcasa)) as telefono, Pfax as fax 
            from DatosPersonales d 
                inner join Usuario u 
                    on u.datos_personales = d.datos_personales
               <cfif isdefined('rs.Usucodigo') and LEN(TRIM(rs.Usucodigo))>
            	where u.Usucodigo = #rs.Usucodigo#
               <cfelse>
                where u.Usucodigo = #session.Usucodigo#
           	   </cfif>
        </cfquery>
        
		<table width="98%" border="0" cellpadding="2" cellspacing="0" align="center">
   			<tr>
        		<td colspan="9">
					<table align="center" width="100%" border="0" cellpadding="0" cellspacing="3">
                    	<cfset PrintHeader()>
                        	<tr>
                                <td class="LetraTitulo">Fecha Emisión:</td>
                                <td class="LetraInfo"><cfoutput>#dateformat(rs.CMPfechapublica,'dd/mm/yyyy')#</cfoutput></td>
                                <td><span class="LetraTitulo">Fecha Límite:</span></td>
                                    <td><span class="LetraInfo"><cfoutput>#dateformat(rs.CMPfmaxofertas,'dd/mm/yyyy')#</cfoutput></span></td>
                            </tr>
                             <tr>
                                    <td class="LetraTitulo">Forma de Pago:</td>
                                    <td class="LetraInfo"><cfoutput>#rs.CMFPdescripcion#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Comprador:</td>
                                    <td colspan="2" class="LetraInfo"><cfoutput>#rs.CMCnombre#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Correo:</td>
                                    <td colspan="2" class="LetraInfo"><cfoutput>#Comprador.correo#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="LetraTitulo">Tel&eacute;fono:</td>
                                    <td class="LetraInfo"><cfoutput>#Comprador.telefono#</cfoutput></td>
                                    <td width="7%" class="LetraTitulo" align="right">Fax:</td>
                                    <td class="LetraInfo"><cfoutput>#Comprador.fax#</cfoutput></td>
                                </tr>
                       </table>  
					</td>
              	</tr>
                <cfset PrintLineasHeader()>  
             
                <cfquery name="rs" dbtype="query">
                    select  ESnumero, DSconsecutivo,
                    	 max(DStipo) as DStipo, 
                         max(Aid) as Aid, 
                         max(DSdescripcion) as DSdescripcion, 
                         max(DSdescalterna) as DSdescalterna, 
                         max(DScant) as DScant, 
                         max(DSmontoest) as DSmontoest , 
                         max(DStotallinest) as DStotallinest, 
                         max(Ucodigo) as Ucodigo 
                        from rs
                        group by ESnumero, DSconsecutivo
                </cfquery>
                
                
               <cfloop query="rs">
                        <cfset PrintLineas()>		                            
               </cfloop> 
		</table>
	 </cfoutput>
</cfif> 
<cffunction name="PrintLineas" output="yes">
	<cfif rs.DStipo eq 'A'>
         <cfquery name="rsArticulo" datasource="#session.dsn#">
           select Adescripcion 
              from Articulos 
            where Aid = #rs.Aid#
         </cfquery> 
         <cfif rsArticulo.recordcount gt 0>
          <cfset LvarArticulo = rsArticulo.Adescripcion>
         </cfif>
     <cfelse>
         <cfset LvarArticulo = '--'>    
     </cfif>	
        <tr>
            <td  class="LetraInfo"><cfoutput>#rs.DSconsecutivo#</cfoutput>&nbsp;</td>
            <td  class="LetraInfo"><cfoutput>#LvarArticulo#</cfoutput>&nbsp;</td>
            <td  class="LetraInfo"><cfoutput>#rs.DSdescripcion#</cfoutput>&nbsp;</td>
            <td  class="LetraInfo"><cfoutput>#rs.DSdescalterna#</cfoutput>&nbsp;</td>
            <td  class="LetraInfo"><cfoutput>#rs.DScant#</cfoutput>&nbsp;</td>
            <td  class="LetraInfo"><cfoutput>#rs.DSmontoest#</cfoutput>&nbsp;</td>
            <td  class="LetraInfo"><cfoutput>#rs.DStotallinest#</cfoutput>&nbsp;</td>  
            <td  class="LetraInfo"><cfoutput>#rs.Ucodigo#</cfoutput>&nbsp;</td>                          
            <td  class="LetraInfo"><cfoutput>#rs.ESnumero#-#rs.DSconsecutivo#</cfoutput>&nbsp;</td>                    
        </tr>	
</cffunction>          
<cffunction name="Printheader" output="yes">
    <tr>
        <td height="25" colspan="3" class="TituloPrincipal">#LvarTitle#</td>    
        <td width="30%"></td>
        <td width="13%" rowspan="4">
        	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl" arTimeStamp="#Empresa.ts_rversion#"> </cfinvoke>
            <cfoutput><img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="100" width="150" /></cfoutput></td>
        <td width="16%"></td>
    </tr>
    <tr>
        <td class="TituloPrincipal">&nbsp;</td>       
        <td colspan="2" class="TituloPrincipal">&nbsp;</td>                               
        <td></td>
        <td></td>    
    </tr>
    <tr>
        <td class="TituloPrincipal"><span class="LetraTitulo">No.Proceso:</span></td>    
        <td colspan="2"><span class="NumeroProceso"><cfoutput>#rs.CMPnumero#</cfoutput></span></td>
        <td width="30%"></td>
        <td width="16%"></td>
    </tr>
    <tr>
        <td align="left" class="LetraTitulo">&nbsp;</td>
        <td colspan="2" align="left">&nbsp;</td>    
        <td></td>
        <td></td>
    </tr>
</cffunction> 
<cffunction name="PrintLineasHeader">
    <tr><td colspan="9"><hr /></td><tr>  
    <tr>
        <td class="LetraEncab">L&iacute;n.</td>
        <td class="LetraEncab">Artículo</td>
        <td class="LetraEncab">Descripción</td>
        <td class="LetraEncab">Descripción Detallada</td>
        <td class="LetraEncab">Cantidad</td>
        <td class="LetraEncab">Precio</td>
        <td class="LetraEncab">Importe</td>
        <td class="LetraEncab">UDM</td>
        <td class="LetraEncab">Solicitud</td>			
    </tr>
    <tr><td colspan="9"><hr /></td><tr>
</cffunction>
