<cfif isDefined("Url.ConceptoSAT") and not isDefined("Form.ConceptoSAT")>
	<cfset Form.ConceptoSAT = Url.ConceptoSAT>
</cfif>
<cfif isDefined("url.formato") and not isDefined("Form.formato")>
	<cfset Form.formato = url.formato>
</cfif>
<cfif isDefined("url.TipoConceptoSAT") and not isDefined("Form.TipoConceptoSAT")>
	<cfset Form.TipoConceptoSAT = url.TipoConceptoSAT>
</cfif>
<!---<cf_dump var="#url#">--->
<!--- Consultas --->
<!--- Detalles de Conceptos --->
<cfquery name="rsDetalle" datasource="#Session.DSN#">
    select cs.RHCSATtipo, cs.RHCSATcodigo as RHCSATcodigo, cs.RHCSATdescripcion as satDescripcion, ci.CIcodigo as Codigo, ci.CIdescripcion as Descripcion
    from RHCFDIConceptoSAT cs
    inner join CIncidentes ci
    on cs.RHCSATid=ci.RHCSATid
    where cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    <cfif Form.ConceptoSAT gt 0>
    	and cs.RHCSATid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ConceptoSAT#">
    </cfif>
    <cfif Form.TipoConceptoSAT neq "X">
		and cs.RHCSATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoConceptoSAT#">
    </cfif>
    union
    select cs.RHCSATtipo, cs.RHCSATcodigo as RHCSATcodigo, cs.RHCSATdescripcion as satDescripcion, ci.TDcodigo as Codigo, ci.TDdescripcion as Descripcion
    from RHCFDIConceptoSAT cs
    inner join TDeduccion ci
    on cs.RHCSATid=ci.RHCSATid
    where cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    <cfif Form.ConceptoSAT gt 0>
    	and cs.RHCSATid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ConceptoSAT#">
    </cfif>
    <cfif Form.TipoConceptoSAT neq "X">
		and cs.RHCSATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoConceptoSAT#">
    </cfif>
    union
    select cSAT.RHCSATtipo, cSAT.RHCSATcodigo as RHCSATcodigo, cSAT.RHCSATdescripcion as satDescripcion, cs.ECcodigo as Codigo, cs.ECdescripcion  as Descripcion  
    from ECargas cs
    inner join dbo.RHCFDIConceptoSAT cSAT
    on cs.Ecodigo = cSAT.Ecodigo and cs.RHCSATid=cSAT.RHCSATid
    where cSAT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    <cfif Form.ConceptoSAT gt 0>
    	and cs.RHCSATid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ConceptoSAT#">
    </cfif>
    <cfif Form.TipoConceptoSAT neq "X">
		and cSAT.RHCSATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoConceptoSAT#">
    </cfif>
    union
    select cSAT.RHCSATtipo, cSAT.RHCSATcodigo as RHCSATcodigo, cSAT.RHCSATdescripcion as satDescripcion,cs.CScodigo as Codigo, cs.CSdescripcion as Descripcion 
    from ComponentesSalariales cs
    inner join dbo.RHCFDIConceptoSAT cSAT
    on cs.Ecodigo = cSAT.Ecodigo and cs.RHCSATid=cSAT.RHCSATid
    where cSAT.RHCSATcodigo='001' and 
		  cSAT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    <cfif Form.ConceptoSAT gt 0>
    	and cs.RHCSATid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ConceptoSAT#">
    </cfif>
    <cfif Form.TipoConceptoSAT neq "X">
		and cSAT.RHCSATtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoConceptoSAT#">
    </cfif>
    order by RHCSATtipo,RHCSATcodigo
</cfquery>

<!---<cf_dump var="#rsDetalle#">--->

<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- Encabezado del Reporte --->
<cfif rsDetalle.REcordCount gt 0>
    <cf_templatecss>
    <link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
    
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConceptosSAT"
		Default="Reporte de Conceptos SAT"
		returnvariable="LB_ConceptosSAT"/>
        
    <cfif isDefined("Form.formato") and Form.formato eq "flashpaper">    
		<cfreport format="#url.formato#" template= "ConceptosSAT.cfr" query="rsDetalle">
			<cfreportparam name="Edescripcion" 	value="#Session.Enombre#">
			<cfreportparam name="Titulo" 		value="#LB_ConceptosSAT#">
		</cfreport>
    <cfelse>    
    
    <!--- <cf_sifHTML2Word listTitle="#LB_ConceptosSAT#">--->
     <cf_htmlreportsheaders
        title="#LB_ConceptosSAT#" 
        filename="ConceptosSAT#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
        ira="repConceptosSAT.cfm">    
            
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
        <tr>
            <td colspan="4" align="center">
                <table width="100%" cellpadding="0" cellspacing="0">
                    <tr><td>
                    <cf_EncReporte
                        Titulo="#LB_ConceptosSAT#"
                        Color="##E3EDEF"
                        cols="4"
                        filtro1=""
                        filtro2=""
                    >
                    </td></tr>
                </table>
            </td>
        </tr>
        <tr> 
            <td>&nbsp;</td>
        </tr>
        <tr> 
        	<td>&nbsp;</td>        
            <td nowrap class="FileLabel"> <div align="left"><cf_translate  key="LB_CodigoSAT">Codigo SAT</cf_translate></div></td>
            <td nowrap class="FileLabel"> <div align="left"><cf_translate  key="LB_DescricionSAT">Descripción SAT</cf_translate></div></td>
        </tr>
        <tr>  
        	<td>&nbsp;</td>        
        	<td>&nbsp;</td>
            <td nowrap class="FileLabel"> <div align="left"><cf_translate  key="LB_CodigoConcepto">Código Concepto</cf_translate></div></td>
            <td nowrap class="FileLabel"> <div align="left"><cf_translate  key="LB_DescConcepto">Descripción Concepto</cf_translate></div></td>
        </tr>
    
		<cfset vCodigoSAT = ''>
        <cfoutput query="rsDetalle">
            <cfflush interval="512">
            <cfif vCodigoSAT neq rsDetalle.RHCSATcodigo>
                <cfset vCodigoSAT = #rsDetalle.RHCSATcodigo#>
                <tr>
        			<td>&nbsp;</td>
                    <td nowrap class="FileLabel" align="left">#trim(rsDetalle.RHCSATcodigo)#</td>
                    <td nowrap class="FileLabel" align="left">#trim(rsDetalle.satDescripcion)#</td>
                </tr>
            </cfif>
            <tr>
        		<td>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap align="left">"#trim(rsDetalle.Codigo)#"</td>
                <td nowrap align="left">#trim(rsDetalle.Descripcion)#</td>
            </tr>
        </cfoutput> 
        <tr> 
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4" align="center"> <strong>*** <cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate> ***</strong> </td>
        <tr> 
            <td colspan="4">&nbsp;</td>
        </tr>
    </table>
	<!---</cf_sifHTML2Word>--->
    </cfif>
<cfelse>
    <table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
        <tr>
            <tr> 
              <td colspan="4">&nbsp;</td>
            </tr>
              <td colspan="4" align="center"> <strong>*** <cf_translate  key="LB_LaConsultaNoGeneroNingunResultado">La Consulta No Gener&oacute; Ning&uacute;n Resultado</cf_translate> *** </strong> </td>
            <tr> 
              <td colspan="4">&nbsp;</td>
            </tr>
        </tr>
    </table>	
</cfif>