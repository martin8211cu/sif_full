<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Puestos"
	Default="Puestos"
	returnvariable="LB_Puestos"/>
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Factores"
	Default="Factores"
	returnvariable="LB_Factores"/>  

<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Sin_Centro_Funcional"
	Default="Sin Centro Funcional"
	returnvariable="LB_Sin_Centro_Funcional"/>      

<cfset tienefiltros = false>


<cfif 	(isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) )
		or (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto))  )
 		or (isdefined("form.CFid") and len(trim(form.CFid)) )
		or (isdefined("form.tienefiltros") and len(trim(form.tienefiltros)) )
		 >
    <cfset tienefiltros = true>       
</cfif> 

<cfquery name="rsfactor" datasource="#session.DSN#">
    select RHFid,RHFcodigo,RHFdescripcion
    from RHFactores
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	Order by RHFcodigo
</cfquery>  
<cfset cantidadFactores = -1>

<cfif rsfactor.recordCount gt 0>
	<cfset cantidadFactores = rsfactor.recordCount>
</cfif>

<cfquery name="rsPuesto" datasource="#session.DSN#">
    select a.RHPcodigo,coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext ,a.RHPdescpuesto,
    case when b.CFcodigo is not null then
    	{fn concat(b.CFcodigo,{fn concat('-',b.CFdescripcion)})}
    else
    	'#LB_Sin_Centro_Funcional#'
    end as  CFdescripcion,
    case when 
    	(select  count(c.RHGid) from RHGradosFactorPuesto c
         where a.Ecodigo = c.Ecodigo and  a.RHPcodigo = c.RHPcodigo and RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric"> ) = #cantidadFactores#  
    then '<img src=''/cfmx/rh/imagenes/stop2.gif'' border=''0''>' 
    else '<img src=''/cfmx/rh/imagenes/stop3.gif'' border=''0''>'
    end as situacion
    from RHPuestos a
    left outer join CFuncional b
    	on  a.Ecodigo = b.Ecodigo
        and a.CFid   = b.CFid
    left outer join RHGradosFactorPuesto c
    	on   a.Ecodigo = c.Ecodigo
    	and  a.RHPcodigo = c.RHPcodigo   
        and RHVPid = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif VARUsaPropuestos eq 1>
		and coalesce(a.RHPropuesto,0) = 1 and a.RHPactivo = 0
	<cfelse>
    	and  coalesce(a.RHPropuesto,0) = 0
	</cfif>
    
    <cfif tienefiltros>
    	<cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
            and upper(a.RHPcodigo) like  '%#Ucase(form.FRHPcodigo)#%'
		</cfif>
        
        <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
            and upper(a.RHPdescpuesto) like  '%#Ucase(form.FRHPdescpuesto)#%'
		</cfif>
        
		<cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
        	and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>        
    <cfelse>
    	and 1 = 2
	</cfif>
  	Order by CFdescripcion,RHPdescpuesto
</cfquery>
            

<cfquery name="rsGrado" datasource="#session.DSN#">
    select RHFid,RHGid,RHGdescripcion,
	RHGcodigo
    from RHGrados 
    order by RHFid,RHGid
</cfquery>



<cfquery name="rsfactorGrado" datasource="#session.DSN#">
    select count(RHFid)as cantidad
    from RHFactores
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and RHFid not in (select RHFid from RHGrados )
</cfquery>

<cfset Cantidad =  rsfactor.recordCount + 1>
<cfset totalcel =  Cantidad + 1>
<cfset TamCel   =  100 /(totalcel)>
<cfset VarRHFid   =  -1>
<cfset VarRHGid    =  -1>
<cfset VarRHPcodigo   =  "">
<cfset VarCFdescripcion   =  "">  
<cfset VarRHPcodigoForm   =  ""> 
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
		
</style>

<form name="form1" method="post" action="SQLClasificacionGradoPuesto.cfm">
  <input type="hidden" name="SEL" value="2">
  <input type="hidden" name="RHVPid" value="<cfoutput>#form.RHVPid#</cfoutput>">
  <input type="hidden" name="tienefiltros" value="<cfoutput>#tienefiltros#</cfoutput>">
  <cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td colspan="#totalcel#"><fieldset>
          <table width="100%" border="0" cellpadding="1" cellspacing="3">
            <tr>
              <td ><img src="/cfmx/rh/imagenes/stop.gif"/><font  style="font-size:10px">
                <cf_translate  key="LB_Existe_Factores_que_no_tienen_grados_definidos">Existe Factores que no tienen grados definidos</cf_translate>
              </font> </td>
              <td ><img src="/cfmx/rh/imagenes/stop3.gif"/><font  style="font-size:10px">
                <cf_translate  key="LB_Puesto_con_factores_pendientes_de_clasificar">Puesto con factores pendientes de clasificar</cf_translate>
              </font> </td>
              <td ><img src="/cfmx/rh/imagenes/stop2.gif"/><font  style="font-size:10px">
                <cf_translate  key="LB_Puesto_con_todos_los_factores_clasificados">Puesto con todos los factores clasificados</cf_translate>
              </font> </td>
            </tr>
            <cfif rsPuesto.recordCount eq 0>
                <tr>
                    <td colspan="3" align="center" ><font  style="font-size:11px">***<cf_translate  key="LB_Seleccione_filtrar_para_ver_los_puesto">Seleccione filtrar para ver los puesto</cf_translate>***</font></td>
                </tr>
            </cfif>
          </table>
        </fieldset></td>
      </tr>
      <!--- ************************************************************************************* --->
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="MSG_Lista_de_Puestos"
        Default="Lista de Puestos "
        returnvariable="MSG_Lista_de_Puestos"/>
      <tr>
        <td colspan="#totalcel#"><fieldset>
          <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td width="13%"><font  style="font-size:10px">
                <cf_translate key="LB_Puesto">Puesto:</cf_translate>
              </font> </td>
              <td width="10%" colspan="3" nowrap>
                     <input 
                        name="FRHPcodigo" 
                        type="text" 
                        id="FRHPcodigo"  
                        maxlength="10"
                        size="10"
                        tabindex="1"
                        value="<cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>#form.FRHPcodigo#</cfif>" />
                      <input 
                        name="FRHPdescpuesto" 
                        type="text" 
                        id="FRHPdescpuesto"  
                        maxlength="40"
                        size="39"
                        tabindex="1"
                        value="<cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>#form.FRHPdescpuesto#</cfif>" />
                    <a  href="##" tabindex="-1">
                    <img src="/cfmx/rh/imagenes/Description.gif" 
                        alt="#MSG_Lista_de_Puestos#" 
                        name="imagen" 
                        width="18" 
                        height="14" 
                        border="0" 
                        align="absmiddle" 
                        onClick='javascript: doConlisPuestos();'></a>
              </td>
              
              <td width="55%"  rowspan="2"><cf_botones values="Filtrar,Limpiar,Aplicar,Reporte" tabindex="1">
              </td>
            </tr>
            <cfif VARUsaPropuestos eq 0>
                <tr>
                  <td width="15%" nowrap><font  style="font-size:10px">
                    <cf_translate key="LB_CentroFuncional">Centro Funcional:</cf_translate>
                  </font> </td>
                  <td width="10%"  colspan="3"><cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
                      <cfquery name="rsForm" datasource="#session.DSN#">
                                            select	
                                            CFid,
                                            CFcodigo,
                                            CFdescripcion
                                            from  CFuncional 
                                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                            and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
                                        </cfquery>
                      <cf_rhcfuncional query="#rsForm#" tabindex="1">
                      <cfelse>
                      <cf_rhcfuncional tabindex="1">
                    </cfif>
                  </td>
                </tr>
            </cfif>
          </table>
        </fieldset></td>
      </tr>
      <!--- ************************************************************************************* --->
      <tr valign="bottom">
        <td  bgcolor="##CCCCCC" class="LTtopline" rowspan="2"><b><font  style="font-size:10px">#LB_Puestos#</font></b></td>
        <td  bgcolor="##CCCCCC" class="RLTtopline" align="center" colspan="#Cantidad#"><b><font  style="font-size:10px">#LB_Factores#</font></b></td>
      </tr>
      <tr>
        <cfloop query="rsfactor">
          <td bgcolor="##CCCCCC" class="LTtopline" align="center"><font  style="font-size:10px">&nbsp;#trim(rsfactor.RHFdescripcion)#&nbsp;</font> </td>
        </cfloop>
        <td bgcolor="##CCCCCC" class="RLTtopline">&nbsp;</td>
      </tr>
      <cfloop query="rsPuesto">
        <cfif rsPuesto.CFdescripcion neq VarCFdescripcion>
          <cfset VarCFdescripcion   =  rsPuesto.CFdescripcion>
          <tr>
            <td class="topline" colspan="#totalcel#" align="center">&nbsp;</td>
          </tr>
          <tr>
            <td bgcolor="##CCCCCC"  class="LRTtopline"   colspan="#totalcel#">
            	<b><font  style="font-size:10px">
              <cf_translate key="LB_CentroFuncional">Centro Funcional:</cf_translate>
              &nbsp;#trim(rsPuesto.CFdescripcion)#</font></b></td>
          </tr>
        </cfif>
        <cfif rsPuesto.RHPcodigo neq VarRHPcodigo>
          <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
           <cfset VarRHPcodigoForm   =  replace(VarRHPcodigo,"-","_","All")>
          <tr>
            <td class="LTtopline"  nowrap><font  style="font-size:10px">#trim(rsPuesto.RHPcodigoext)#-#trim(rsPuesto.RHPdescpuesto)#</font></td>
            <cfloop query="rsfactor">
              	<cfset VarRHFid   =  rsfactor.RHFid>
                <cfquery name="rsGradoF"  dbtype="query">
                    select RHGid,RHGdescripcion,RHGcodigo
                    from rsGrado
                    where  RHFid = #VarRHFid#
                </cfquery>
				<cfquery name="rsGradot" datasource="#session.DSN#">
					select  RHGid
                    from RHGradosFactorPuesto  
                    where  RHFid   		= <cfqueryparam value="#VarRHFid#" cfsqltype="cf_sql_numeric">
                    and    RHPcodigo   	= <cfqueryparam value="#VarRHPcodigo#" cfsqltype="cf_sql_char">
                    and    Ecodigo   	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and    RHVPid       = <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
                </cfquery>
				<cfif rsGradoF.recordCount eq 0>
                    <td class="LTtopline" align="center"><select name="GRD_#trim(VarRHPcodigoForm)#_#trim(VarRHFid)#" tabindex="1" style="font-size:10px">
                        <option value="">No tiene grados</option>
                      </select>
                    </td>
				<cfelse>
                    <td class="LTtopline" align="center"><select name="GRD_#trim(VarRHPcodigoForm)#_#trim(VarRHFid)#" tabindex="1" style="font-size:10px">
                        <option value=""></option>
                        <cfloop query="rsGradoF">
                          <option value="#rsGradoF.RHGid#" <cfif rsGradot.recordCount gt 0 and rsGradot.RHGid eq rsGradoF.RHGid> selected</cfif>>#rsGradoF.RHGdescripcion# </option>
                        </cfloop>
                      </select>
                    </td>
                </cfif>
            </cfloop>
            <td class="RLTtopline">
				<cfif isdefined("rsfactorGrado") and rsfactorGrado.cantidad gt 0>
                    <img src="/cfmx/rh/imagenes/stop.gif" />
                <cfelse>
                  #rsPuesto.situacion#
                </cfif>
            </td>
          </tr>
        </cfif>
      </cfloop>
      <tr >
        <td  class="topline" colspan="#totalcel#" align="center">&nbsp;</td>
      </tr>
    </table>
  </cfoutput>
</form>      
<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.form1.action='registro_valoracion.cfm?SEL=2&RHVPid=<cfoutput>#form.RHVPid#</cfoutput>';
		document.form1.submit();
	}
	
	function funcLimpiar(){
		document.form1.FRHPcodigo.value='';
		document.form1.FRHPdescpuesto.value='';
		document.form1.CFid.value='';
		document.form1.CFcodigo.value='';
		document.form1.CFdescripcion.value='';
		document.form1.submit();
	}
	                 

	function  doConlisPuestos (){
		var params ="";
		params = "/cfmx/rh/Utiles/ConlisPuesto.cfm?form=form1&nameExt=FRHPcodigo&name=FRHPcodigo&desc=FRHPdescpuesto&conexion=<cfoutput>#session.DSN#</cfoutput><cfif VARUsaPropuestos eq 1>&Propuestos=S</cfif>";
		open(params,'ConlisPexternos','left=200,top=150,scrollbars=yes,resizable=yes,width=650,height=400')
	}
	
	function funcReporte(){
		document.form1.action='RClasificacionGradoPuesto.cfm?SEL=2&RHVPid=<cfoutput>#form.RHVPid#</cfoutput>';
		document.form1.submit();
	}

</script>    