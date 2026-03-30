<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td>
	
		<cfif isdefined("form.TPid") and len(trim(form.TPid))>
				<cfinclude template="/saci/das/gestion/gestion-cuenta-tarea.cfm">
		<cfelse> 
			<form action="#CurrentPage#" name="listaTarea" method="post" style="margin: 0;">
				<cfinclude template="gestion-hiddens.cfm">
				
				<cfinvoke 
				 component="sif.Componentes.pListas" 
				 method="pLista">
					<cfinvokeargument name="tabla" value="ISBtareaProgramada a
															inner join ISBcuenta c
																on c.CTid = a.CTid
																and a.CTid =#form.cue#		
																and c.Pquien =#form.cli#
															left outer join  ISBproducto f
																on f.CTid=a.CTid
																and f.Contratoid=a.Contratoid
																and f.CTcondicion not in ('C','0','X')
																and f.CTcondicion = '1'
															left outer join ISBpaquete b
																on b.PQcodigo = f.PQcodigo"/>
					<cfinvokeargument name="columnas" value="a.TPid,a.TPdescripcion,a.TPinsercion,a.TPfecha,a.TPtipo,
															case a.TPtipo
															when 'CP' then'CP-Cambio de Paquete'
															when 'CFC' then'CFC-Cambio de Forma de Cobro'
															when 'RS' then'RS-Retiro de Servicio'
															end as tipo,b.PQnombre,b.PQnombre as paquete"/> 
					<cfinvokeargument name="desplegar" value="paquete,TPdescripcion,TPfecha"/>
					<cfinvokeargument name="etiquetas" value="Paquete,Tarea,Fecha Programada"/>
					<cfinvokeargument name="filtro" value="a.CTid =#form.cue#
															and a.TPestado = 'P'
															order by a.TPfecha"/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="#CurrentPage#"/>
					<cfinvokeargument name="botones" value=""/>
					<cfinvokeargument name="conexion" value="#Session.DSN#"/>
					<cfinvokeargument name="keys" value="TPid"/>
					<cfinvokeargument name="incluyeform" value="false"/>
					<cfinvokeargument name="formName" value="listaTarea"/>
					<cfinvokeargument name="form_method" value="get"/>
					<cfinvokeargument name="formatos" value="S,S,D"/>
					<cfinvokeargument name="mostrar_filtro" value="false"/>
					<cfinvokeargument name="filtrar_automatico" value="false"/>
					<cfinvokeargument name="filtrar_por" value=""/>
					<cfinvokeargument name="maxrows" value="15"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="EmptyListMsg" value="--- No existen tareas programadas ---"/>
				</cfinvoke>	
			</form>
		</cfif>
	</td>
  </tr>
</table>
</cfoutput>
