<!---
	Catalogo de Status de las tarjetas de credito
	Creado por Hector Garcia Beita
	Fecha: 22/07/2011
--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cf_templateheader title="Status de Tarjetas de Credito">
	<cf_templatecss>
    
	<!---portlet de navegacion 2do--->
 	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Status de la Tarjeta de Credito">
        <table width="100%" align="center" cellpadding="0" cellspacing="0">
          <!---portlet de navegacion 2do--->
        	<tr>
            	<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
            </tr>
            
            <tr>
            	<td width="50%" valign="top">
           
			  <!---Descripcion para utilizar el filtro de la Lista--->
              <cfif isdefined('url.Descripcion_U') and not isdefined('form.Descripcion_U')>
              	<cfparam name="form.Descripcion_U" default="#url.Descripcion_U#">
              </cfif>
          
         	 <!---Filtro para utilizar la Lista--->
          	  <cfinclude template="TCEStatusTarjetas-filtro.cfm">
          	  <cfset navegacion = "">
         	  <cfif isdefined("Form.Descripcion_U") and Len(Trim(Form.Descripcion_U)) NEQ 0>
              	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion_U=" & Form.Descripcion_U>
         	  </cfif>
          
          	<!---Qry para la Lista--->
          	<cfquery name="rs_lista" datasource="#session.DSN#">
            	Select 
                      CBSTcodigo as CodigoTarjeta
                      <cfif IsDefined("Form.Descripcion_U") and Len(Trim(Form.Descripcion_U)) neq 0>
                      ,'#Descripcion_U#' as Descripcion_U
                      </cfif> 
                       ,'<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# coalesce((case CBSTActiva when 0 then 'un' end),rtrim(''))  #_Cat# 'checked.gif''>'  as Estado
                       ,CBSTDescripcion as Descripcion 
                from CBStatusTarjetaCredito   
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                <cfif isdefined('form.Descripcion_U') and form.Descripcion_U NEQ ''>
                                	and upper(CBSTDescripcion) like upper('%#form.Descripcion_U#%')
                                </cfif>	 
                order by CBSTcodigo,CBSTDescripcion  
            </cfquery>
          <cfinvoke 
          		component="sif.Componentes.pListas"
                method="pListaQuery"
                returnvariable="pListaRet">
          <cfinvokeargument name="query" value="#rs_lista#"/>
          <cfinvokeargument name="desplegar" value="CodigoTarjeta, Descripcion,Estado"/>
          <cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n,Estado"/>
          <cfinvokeargument name="formatos" value="V, V, IMAG"/>
          <cfinvokeargument name="align" value="left, left,center"/>
          <cfinvokeargument name="ajustar" value="N"/>
          <cfinvokeargument name="irA" value="TCEStatusTarjetas.cfm"/>
          <cfinvokeargument name="keys" value="CodigoTarjeta"/>
          <cfinvokeargument name="showemptylistmsg" value="true"/>
          </cfinvoke>
            </td>
          
          
            <td width="50%" valign="top"><cfinclude template="TCEStatusTarjetas-form.cfm"></td>
          </tr>
        </table>
<cf_web_portlet_end>
<cf_templatefooter>
