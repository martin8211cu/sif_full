<cf_templateheader title="Consulta de Tareas Programadas por cliente">
	<cf_web_portlet_start titulo="Consulta de Tareas Programadas por cliente">

	<cfif isdefined("url.Pquien") and len(trim(url.Pquien))>
		<cfset form.Pquien = url.Pquien>
	</cfif>

 	<cfquery name="rsPQcodigo" datasource="#session.DSN#">
		select '-1' as value
				, '--Todos--' as description
		union	
			Select distinct f.PQcodigo as value
				, b.PQnombre as description			
			
			from ISBtareaProgramada a
				inner join ISBcuenta c
					on c.CTid = a.CTid
			
				inner join ISBpersona p
					on p.Pquien=c.Pquien
			
				left outer join  ISBproducto f
					on f.CTid=c.CTid
						and f.Contratoid=a.Contratoid
						and f.CTcondicion not in ('C','0','X')
						and f.CTcondicion = '1'

				left outer join ISBpaquete b
					on b.PQcodigo = f.PQcodigo
								
			where a.TPestado = 'P'
				and a.Contratoid is not null
		order by value
	</cfquery>

	<form method="post" name="formLista" action="tareasProg-sql.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tituloListas">
		  <tr>
			<td width="10%" align="right"><strong>Cliente:</strong></td>
			<td width="90%">
			
				<cfset idCliente = "">
				<cfif isdefined('form.Pquien') and form.Pquien NEQ ''>
					<cfset idCliente = form.Pquien>
				</cfif>
			
 				<cf_identificacion 
					ocultarPersoneria="true"
					editable="false"
					id="#idCliente#"
					form="formLista"
					pintaEtiq="false">				
			</td>
		  </tr>
		</table>
		
		<cfset filtroExtra = "">
		<cfset navegacion = "">		
		<cfif isdefined('form.Pquien') and form.Pquien NEQ ''>
			<cfset filtroExtra = " and c.Pquien = " & form.Pquien>			
			<cfset navegacion = "&Pquien=" & form.Pquien>					
		</cfif>		

		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaRH"
			returnvariable="pListaRet"
				columnas="
						a.TPid
						, (p.Pnombre || ' ' || Papellido || ' ' || Papellido2) as cliente
						, c.CUECUE
						, f.PQcodigo
						, b.PQnombre as paquete
						, a.TPdescripcion
						, a.TPfecha
						, lo.LGlogin"
				tabla="
						ISBtareaProgramada a
							inner join ISBcuenta c
								on c.CTid = a.CTid
						
							inner join ISBpersona p
								on p.Pquien=c.Pquien
						
							left outer join  ISBproducto f
								on f.CTid=c.CTid
									and f.Contratoid=a.Contratoid
									and f.CTcondicion not in ('C','0','X')
									and f.CTcondicion = '1'
						
							left outer join ISBpaquete b
								on b.PQcodigo = f.PQcodigo
								
							left outer join ISBlogin lo
								on lo.LGnumero=a.LGnumero
									and lo.Contratoid=a.Contratoid"
				filtro="a.TPestado = 'P'
					#filtroExtra#
					order by cliente, a.TPfecha"
				desplegar="CUECUE,LGlogin,paquete,TPdescripcion,TPfecha"
				etiquetas="Cuenta,Login,Paquete,Tarea,Fecha"
				rspaquete="#rsPQcodigo#"
				formatos="I,S,S,S,D"
				align="left,left,left,left,left"
				showlink="false"
				ajustar="N,N,N,N,N"
				keys="TPid"
				cortes="cliente"
				incluyeForm="false"
				formName="formLista"
				checkboxes="S"
				botones="Borrar"
				MaxRows="15"
				MaxRowsQuery="150"
				navegacion="#navegacion#"
				mostrar_filtro="yes"
				filtrar_por="c.CUECUE,lo.LGlogin,f.PQcodigo,a.TPdescripcion,a.TPfecha"
				filtrar_automatico="yes"				
				irA="tareasProg-sql.cfm" /> 
	<cf_web_portlet_end> 
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	function hayAlgunoMarcado(){
		if (document.formLista.chk) {
			if (document.formLista.chk.value) {
				return document.formLista.chk.checked;
			} else {
				for (var i=0; i<document.formLista.chk.length; i++) {
					if (document.formLista.chk[i].checked) { 
						return true;
					}
				}
			}
		}
		return false;
	}

	function funcBorrar(){
		if(hayAlgunoMarcado()){
			if(confirm('Desea eliminar las tareas seleccionadas ?'))
				return true;
			else
				return false;
		}else{
			return false;
		}
	}

</script>				
