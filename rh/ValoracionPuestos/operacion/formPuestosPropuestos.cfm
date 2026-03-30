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
<cfquery name="rsRHValoracionPuesto" datasource="#session.DSN#">
     select RHVPfhasta from RHValoracionPuesto
     where RHVPid =  <cfqueryparam value="#form.RHVPid#" cfsqltype="cf_sql_numeric">
     and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsPuesto" datasource="#session.DSN#">
    select 
    a.DEid,
    {fn concat({fn concat({fn concat({fn concat(d.DEnombre , ' ' )}, d.DEapellido1 )}, ' ' )}, d.DEapellido2 )} as nombre,
    c.RHPcodigo,
    c.RHPdescpuesto,
    coalesce(c.RHPcodigoext,c.RHPcodigo ) as RHPcodigoext, 
    case when x.CFcodigo is not null then
    	{fn concat(x.CFcodigo,{fn concat('-',x.CFdescripcion)})}
    else
    	'#LB_Sin_Centro_Funcional#'
    end as  CFdescripcion,
    LTsalario
    from LineaTiempo  a 
    inner join RHPlazas b
        on  a.RHPid  = b.RHPid 
        and a.Ecodigo = b.Ecodigo
    inner join RHPuestos c
        on  b.RHPpuesto = c.RHPcodigo 
        and b.Ecodigo   = c.Ecodigo
    inner join DatosEmpleado d
        on  a.DEid = d.DEid
    left outer join CFuncional x
        on  c.Ecodigo = x.Ecodigo
        and c.CFid    = x.CFid    
    where <cfqueryparam value="#rsRHValoracionPuesto.RHVPfhasta#" cfsqltype="cf_sql_timestamp"> between LTdesde and LThasta
    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    <cfif tienefiltros>
        <cfif (isdefined("form.FRHPcodigo") and len(trim(form.FRHPcodigo)))>
            and upper(c.RHPcodigo) like  '%#Ucase(form.FRHPcodigo)#%'
        </cfif>
        
        <cfif (isdefined("form.FRHPdescpuesto") and len(trim(form.FRHPdescpuesto)))>
            and upper(c.RHPdescpuesto) like  '%#Ucase(form.FRHPdescpuesto)#%'
        </cfif>
        <cfif (isdefined("form.CFid") and len(trim(form.CFid)))>
            and x.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
        </cfif>        
     <cfelse>
        and 1 = 2  
    </cfif>
    Order by CFdescripcion,RHPdescpuesto,{fn concat({fn concat({fn concat({fn concat(d.DEnombre , ' ' )}, d.DEapellido1 )}, ' ' )}, d.DEapellido2 )}
</cfquery>

            
<cfset totalcel =  4>
<cfset TamCel   =  100 /(totalcel)>
<cfset VarRHPcodigo   =  "">
<cfset VarRHPcodigoForm   =  ""> 
<cfset VarCFdescripcion  =  ""> 
<cfset VarDeid  =  -1> 
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
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" method="post" action="SQLPuestosPropuestos.cfm">
  <input type="hidden" name="SEL" value="4">
  <input type="hidden" name="RHVPid" value="<cfoutput>#form.RHVPid#</cfoutput>">
  <input type="hidden" name="tienefiltros" value="<cfoutput>#tienefiltros#</cfoutput>">
  <cfoutput>
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
      
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
              <td width="10%" colspan="3" nowrap><input 
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
                    onClick='javascript: doConlisPuestos();'>   </a>          </td>
              
              <td width="55%"  rowspan="2"><cf_botones values="Filtrar,Limpiar,Aplicar" tabindex="1">              </td>
            </tr>
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
                </cfif>              </td>
            </tr>
          </table>
        </fieldset></td>
      </tr>
      
      <!--- ************************************************************************************* --->
      <tr valign="bottom">
        <td  align="left" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_Colaborador">Colaborador</cf_translate></font></b></td>
        <td  align="left" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_PosicionActual">Posici&oacute;n Actual</cf_translate></font></b></td>
        <td  align="left" bgcolor="##CCCCCC" class="LTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_PosicionPropuesta">Posici&oacute;n Propuesta</cf_translate></font></b></td>
        <td  align="right" bgcolor="##CCCCCC" class="RLTtopline"><b><font  style="font-size:10px"><cf_translate  key="LB_SalarioActual">Salario Actual</cf_translate></font></b></td>
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
        <cfif rsPuesto.Deid neq VarDeid>
           <cfset VarRHPcodigo   =  rsPuesto.RHPcodigo>
           <cfset VarRHPcodigoForm   =  trim(replace(VarRHPcodigo,"-","_","All"))>
  		   <cfset VarDeid  =  rsPuesto.Deid> 
           
           <cfquery name="rs_PuestoSug" datasource="#session.DSN#">
                select b.RHPcodigo as Cod_#VarRHPcodigoForm#_#VarDeid#,
                	   b.RHPdescpuesto as Des_#VarRHPcodigoForm#_#VarDeid#,
                       coalesce(b.RHPcodigoext,b.RHPcodigo) as  Codext_#VarRHPcodigoForm#_#VarDeid#
                from RHPropuestaPuesto  a
                inner join RHPuestos b
                	on a.RHPcodigoP = b.RHPcodigo
                    and a.Ecodigo = b.Ecodigo
                where  a.RHVPid       = <cfqueryparam value="#form.RHVPid#"   cfsqltype="cf_sql_numeric">
                and    a.RHPcodigo    = <cfqueryparam value="#VarRHPcodigo#" 		cfsqltype="cf_sql_char">
                and    a.DEid         = <cfqueryparam value="#VarDeid#" 		cfsqltype="cf_sql_numeric">
            </cfquery> 

           
          <tr>
            <td class="LTtopline"  nowrap><font  style="font-size:10px">#trim(rsPuesto.nombre)#</font></td>
            <td  align="left" class="LTtopline"  nowrap><font  style="font-size:10px">#trim(rsPuesto.RHPcodigoext)#-#trim(rsPuesto.RHPdescpuesto)#</font></td>
            <td  align="left" class="LTtopline"  nowrap>
            	<cfif rs_PuestoSug.recordCount GT 0>
                	<cf_rhpuesto  query="#rs_PuestoSug#" nameExt="Codext_#VarRHPcodigoForm#_#VarDeid#" name="Cod_#VarRHPcodigoForm#_#VarDeid#" desc="Des_#VarRHPcodigoForm#_#VarDeid#" size="30" >	
                <cfelse>
                	<cf_rhpuesto   nameExt="Codext_#VarRHPcodigoForm#_#VarDeid#" name="Cod_#VarRHPcodigoForm#_#VarDeid#" desc="Des_#VarRHPcodigoForm#_#VarDeid#" size="30" >	
				</cfif>
            </td>
            <td align="right" class="RLTtopline" nowrap><font  style="font-size:10px">#LSNumberFormat(rsPuesto.LTsalario,'____,.__')#</font> </td>
            
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
		document.form1.action='registro_valoracion.cfm?SEL=4&RHVPid=<cfoutput>#form.RHVPid#</cfoutput>';
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
		params = "/cfmx/rh/Utiles/ConlisPuesto.cfm?form=form1&nameExt=FRHPcodigo&name=FRHPcodigo&desc=FRHPdescpuesto&conexion=<cfoutput>#session.DSN#</cfoutput>";
		open(params,'ConlisPexternos','left=200,top=150,scrollbars=yes,resizable=yes,width=650,height=400')
	}
	
	function funcReporte(){
		document.form1.action='RClasificacionGradoPuesto.cfm?SEL=2&RHVPid=<cfoutput>#form.RHVPid#</cfoutput>';
		document.form1.submit();
	}

</script>    