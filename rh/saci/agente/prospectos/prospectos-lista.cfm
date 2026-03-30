<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfinvoke 
	component="sif.Componentes.pListas"
	method="pLista"
	returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="ISBprospectos"/>
	<cfinvokeargument name="columnas" value="Pquien as PquienProsp
											, Pid
											, case Ppersoneria 
												when 'J' then  PrazonSocial
												else rtrim(rtrim(Pnombre) || ' ' || rtrim(Papellido) || ' ' || Papellido2) 
											  end as nombre"/>
	<cfinvokeargument name="desplegar" value="Pid,nombre"/> 
	<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Nombre"/>
	<cfinvokeargument name="formatos" value="S,S"/> 									
	<cfinvokeargument name="filtro" value="AGid = #session.saci.agente.id#
											and Pprospectacion not in ('D','F')
										   order by nombre"/> 
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="prospectos.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="emptyListMsg" value=" --- En este momento no hay prospectos por atender --- "/>
	<cfinvokeargument name="keys" value="PquienProsp"/> 
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="filtrar_automatico" value="true"/>
	<cfinvokeargument name="mostrar_filtro" value="true"/>
	<cfinvokeargument name="filtrar_por" value="Pid, case Ppersoneria 
												when 'J' then  PrazonSocial
												else rtrim(rtrim(Pnombre) || ' ' || rtrim(Papellido) || ' ' || Papellido2) end"/>
</cfinvoke>