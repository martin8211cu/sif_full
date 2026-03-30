<cfquery name="rsverifica" datasource="#session.DSN#">
	select count(1) as cantidad
    from Oficinas a
    	inner join QPPromotor b
    		on b.Ocodigo = a.Ocodigo
       	   and b.Ecodigo = a.Ecodigo
    	inner join QPassUsuarioOficina c
        	on c.Ocodigo = a.Ocodigo
           and c.Usucodigo = #session.Usucodigo#
    where a.Ecodigo = #session.Ecodigo#
    and b.QPPestado = '1'
</cfquery>

<cfquery name="rsverificaOfi" datasource="#session.DSN#">
	select min(a.Odescripcion) as Odescripcion
    from Oficinas a
    	inner join QPassUsuarioOficina c
        	on c.Ocodigo = a.Ocodigo
            and c.Ecodigo = a.Ecodigo
           and c.Usucodigo = #session.Usucodigo#
    where a.Ecodigo = #session.Ecodigo#
</cfquery>

<cfif rsverifica.cantidad eq 0>
	<cfthrow message="No se ha definido al menos un promotor activo a la sucursal #rsverificaOfi.Odescripcion#." detail="Esto se hace en el módulo Quick Pass, catálogos, Promotores">
</cfif>

<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start titulo="Asignar Tags a Promotores">
	<br>
	
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				
				<cfset navegacion = "">
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
                        a.QPEAPid,
                        a.QPEAPDocumento,
                        a.QPEAPDescripcion,
                        b.Usulogin,
                        c.QPPcodigo
                    
                    from QPEAsignaPromotor a
                    inner join Usuario b
                        on b.Usucodigo = a.Usucodigo
                    inner join QPPromotor c
                        on c.QPPid = a.QPPid
                    inner join QPassUsuarioOficina d
                        on d.Ocodigo = c.Ocodigo 
                       and d.Usucodigo = #session.Usucodigo#
                    where  c.QPPestado = '1'
                    and a.Ecodigo = #session.Ecodigo#
                    and a.QPEAPEstado = 0
                    and exists(
                                select 1
                                from QPassUsuarioOficina f
                                where f.Usucodigo = #session.Usucodigo#
                                and  f.Ecodigo = #session.Ecodigo#
                                and f.Ecodigo = c.Ecodigo
                                and f.Ocodigo = c.Ocodigo
                            	)
				</cfquery>	
				
				<cfoutput>
				<label for="chkTodos">Lista de Documentos</label>
				</cfoutput>

				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					query="#rsLista#"
					desplegar="QPEAPDocumento, QPEAPDescripcion, Usulogin, QPPcodigo"
					etiquetas="Documento, Descripci&oacute;n, Usuario Envia, Promotor Asignar"
					formatos="S,S,S,S"
					align="left,left,left,left"
					ajustar="S"
					irA="Promotores.cfm"
					keys="QPEAPid"
					maxrows="50"
					pageindex="3"
					navegacion="#navegacion#" 				 
					showEmptyListMsg= "true"
					form_method="post"
					formname= "form2"
					usaAJAX = "no"
					mostrar_filtro ="true"
					/>
			</td>
			<td width="5%">&nbsp;</td>
			<td width="55%" valign="top">
				<cfinclude template="Promotores_form.cfm"> 
			</td>			
		</tr>
	</table>

	<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcFiltrar(){
			document.form2.action='Promotores.cfm';
			document.form2.submit;
		}
</script>		
