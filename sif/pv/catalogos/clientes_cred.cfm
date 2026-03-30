<cfif isdefined("url.CDCcodigo") and len(trim(url.CDCcodigo)) and not isdefined("form.CDCcodigo")>
	<cfset form.CDCcodigo = url.CDCcodigo>
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td align="center">
			<cfinclude template="clientes_cred-form.cfm">	
		</td>
  	</tr>
  	<tr>
    	<td><hr></td>
  	</tr>
  	<tr>
    	<td align="center">
		 	<cfif isdefined('url.CDCidentificacion_F') and not isdefined('form.CDCidentificacion_F')>
				<cfparam name="form.CDCidentificacion_F" default="#url.CDCidentificacion_F#">
			</cfif>
			<cfif isdefined('url.CDCnombre_F') and not isdefined('form.CDCnombre_F')>
				<cfparam name="form.CDCnombre_F" default="#url.CDCnombre_F#">
			</cfif>
	
			<cfset navegacion = "">
			
			<cfif isdefined("Form.CDCidentificacion_F") and Len(Trim(Form.CDCidentificacion_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDCidentificacion_F=" & Form.CDCidentificacion_F>
			</cfif>				
			<cfif isdefined("Form.CDCnombre_F") and Len(Trim(Form.CDCnombre_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDCnombre_F=" & Form.CDCnombre_F>
			</cfif>	
			<cf_dbfunction name="to_char" args="a.SNcodigo"  returnvariable="SNcodigo">
            <cf_dbfunction name="to_char" args="a.CDCcodigo" returnvariable="CDCcodigo">
            
			<cfquery name="lista" datasource="#session.DSN#">
				Select a.CDCcodigo, a.SNcodigo, b.SNnombre, b.SNidentificacion
				<cfif isdefined("Form.CDCidentificacion_F") and Len(Trim(Form.CDCidentificacion_F)) NEQ 0>
					, '#CDCidentificacion_F#' as CDCidentificacion_F
				</cfif>	
				<cfif isdefined("Form.CDCnombre_F") and Len(Trim(Form.CDCnombre_F)) NEQ 0>
					, '#CDCnombre_F#' as CDCnombre_F
				</cfif>
                	, case b.SNinactivo 
                    	when 1 then '<img src="../../imagenes/BajoMinimo.gif" title="Socio Inactivo" width="13" height="13" />' 
                        else '' end as img
                    ,'<img src="../../imagenes/Borrar01_S.gif" title="Eliminar" onclick="return fnBorrar('#_Cat# #SNcodigo# #_Cat#','#_Cat# #CDCcodigo# #_Cat#')" width="13" height="13" />' as del 
				from FACSnegocios a
                    inner join SNegocios b
                        on b.SNcodigo = a.SNcodigo
                       and b.Ecodigo  = a.Ecodigo
				where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CDCcodigo#">
				order by a.SNcodigo
		</cfquery>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
			<cfinvokeargument name="query" 				value="#lista#"/>
			<cfinvokeargument name="etiquetas" 			value="Código,Nombre,,"/>
			<cfinvokeargument name="desplegar" 			value="SNcodigo,SNnombre,img,del"/>
			<cfinvokeargument name="formatos" 			value="V,V,V,V"/>
			<cfinvokeargument name="align" 				value="left,left,left,left,left"/>
			<cfinvokeargument name="ajustar" 			value="N,N,N,N"/>
			<cfinvokeargument name="irA" 				value="clientes.cfm"/>
			<cfinvokeargument name="keys" 				value="SNcodigo, CDCcodigo"/>
			<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
			<cfinvokeargument name="showemptylistmsg" 	value="true"/>
			<cfinvokeargument name="formname"  			value="lista2"/>
			<cfinvokeargument name="pageindex"  		value="2"/>
		</cfinvoke>	
	</td>
  </tr>
  <tr>
  	<td>
    	<img src="../../imagenes/BajoMinimo.gif" width="13" height="13" /> El Socio de negoción fue inactivado en la Administración de Sistema
    </td>
  </tr>
</table>
<script language="javascript" type="text/javascript">
	function fnBorrar(SNcodigo,CDCcodigo)
	{
			if(confirm('Esta seguro que será eliminar el socio de negocio?'))
				location.href = "clientes_cred-sql.cfm?Baja=true&SNcodigo="+SNcodigo+"&CDCcodigo="+CDCcodigo; 
				
			document.lista2.nosubmit = true;
	}
</script>