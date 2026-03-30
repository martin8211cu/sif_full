<cfset fnObtieneDatosLista()>
<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start border="true" titulo="Anulación de Ventas">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr> 
		   <td colspan="2">
			   <cfinclude template="/sif/portlets/pNavegacion.cfm">
		   </td>
	   </tr>
	   <tr> 
		   <td valign="top"> 
			   <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				   <cfinvokeargument name="query"            value="#rsLista#"/>
				   <cfinvokeargument name="desplegar"        value="QPcteDocumento,QPcteNombre,QPvtaTagFecha,QPTPAN,QPctaBancoNum,QPctaSaldosTipo"/>
				   <cfinvokeargument name="etiquetas"        value="Identificación,Cliente,Fecha de la Venta, N° TAG,Cuenta,Tipo"/>
				   <cfinvokeargument name="formatos"         value="S,S,D,S,S,U"/>
				   <cfinvokeargument name="align"            value="left,left,left,left,left,left"/>
				   <cfinvokeargument name="ajustar"          value="S"/>
				   <cfinvokeargument name="irA"              value="QPassAnulaVenta_SQL.cfm"/>
				   <cfinvokeargument name="showEmptyListMsg" value="true"/>
				   <cfinvokeargument name="keys"             value="QPvtaTagid"/>
				   <cfinvokeargument name="mostrar_filtro"   value="true"/>
				   <cfinvokeargument name="showEmptyListMsg" value="true"/>
				   <cfinvokeargument name="showLink"         value="false"/>
				   <cfinvokeargument name="checkboxes"       value="S"/>
				   <cfinvokeargument name="botones"          value="Anular"/>
			   </cfinvoke>
		   </td>
	   </tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="fnObtieneDatosLista" access="private" output="false">
<!---	<cfquery name="rsOficinasUsuario" datasource="#session.dsn#">
		select distinct k.Ocodigo as Ocodigo
		from QPassUsuarioOficina k
		where k.Usucodigo = #session.Usucodigo#
		  and k.Ecodigo   = #session.Ecodigo#
	</cfquery>

	<cfset LvarOficinasUsuario = valuelist(rsOficinasUsuario.Ocodigo)>
--->
   <cfquery name="rsLista" datasource="#session.DSN#">
		select
			d.QPTEstadoActivacion,
			a.QPvtaTagFecha,
			s.QPctaSaldosSaldo,
			a.QPvtaTagid,
			u.Usulogin,
			case s.QPctaSaldosTipo when 2 then 'Prepago' when 1 then 'PostPago' else '' end as QPctaSaldosTipo,			
			b.QPctaBancoNum,
			d.QPTPAN,
			c.QPcteDocumento,
			c.QPcteNombre,
			o.Odescripcion,
			a.BMFecha,   
			a.QPvtaAutoriza,
			a.Ecodigo,             
			a.QPTidTag,        
			a.QPcteid,        
			a.QPctaSaldosid,  
			a.Ocodigo,        
			a.BMusucodigo,
			a.QPvtaEstado 
		from QPventaTags a 
			inner join QPassTag d
				on d.QPTidTag = a.QPTidTag

			inner join QPcliente c 
				on c.QPcteid = a.QPcteid 

			inner join QPcuentaSaldos s
				on s.QPctaSaldosid = a.QPctaSaldosid 
                
            left outer join QPcuentaBanco b
            	on b.QPctaBancoid = s.QPctaBancoid

			inner join Oficinas o
				on o.Ecodigo = a.Ecodigo
				and o.Ocodigo = a.Ocodigo

			inner join Usuario u
				on a.BMusucodigo = u.Usucodigo
			inner join DatosPersonales p
				on p.datos_personales = u.datos_personales

		where a.Ecodigo = #session.Ecodigo#
		  and a.QPvtaEstado = 1
<!---		  and a.Ocodigo in (#LvarOficinasUsuario#)	
--->		
		<cfif isdefined ('form.filtro_QPcteDocumento') and len(trim(form.filtro_QPcteDocumento)) gt 0>
			 and lower(c.QPcteDocumento) like lower('%#form.filtro_QPcteDocumento#%')
		</cfif>
		
		<cfif isdefined ('form.filtro_QPcteNombre') and len(trim(form.filtro_QPcteNombre)) gt 0>
			 and lower(c.QPcteNombre) like lower('%#form.filtro_QPcteNombre#%')
		</cfif>
		
		<cfif isdefined ('form.filtro_QPvtaTagFecha') and len(trim(form.filtro_QPvtaTagFecha)) gt 0 and not isdefined ('form.FILTRO_FECHASMAYORES')>
			 and a.QPvtaTagFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.filtro_QPvtaTagFecha)#">
		</cfif>
			 
		<cfif isdefined ('form.filtro_QPvtaTagFecha') and len(trim(form.filtro_QPvtaTagFecha)) gt 0 and  isdefined ('form.FILTRO_FECHASMAYORES')>
			 and a.QPvtaTagFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.filtro_QPvtaTagFecha)#">
		</cfif>
		
		<cfif isdefined ('form.filtro_QPTPAN') and len(trim(form.filtro_QPTPAN)) gt 0>
			 and d.QPTPAN like '%#form.filtro_QPTPAN#%'
		</cfif>
		
		<cfif isdefined ('form.filtro_QPctaBancoNum') and len(trim(form.filtro_QPctaBancoNum)) gt 0>
			 and lower(b.QPctaBancoNum) like lower('%#form.filtro_QPctaBancoNum#%')
		</cfif>
		
		<cfif isdefined ('form.filtro_QPctaSaldosTipo') and len(trim(form.filtro_QPctaSaldosTipo)) gt 0>
			 and lower(QPctaSaldosTipo) like lower('%#form.filtro_QPctaSaldosTipo#%')
		</cfif>
	   order by o.Ocodigo, a.QPvtaTagid desc
   </cfquery>
</cffunction>

    <script language="javascript1" type="text/javascript">
		function funcAnular(){
			if (confirm("Esta seguro de que desea Anular esta venta?")) {
				return true;
			}
			return false;
		}		
	</script>