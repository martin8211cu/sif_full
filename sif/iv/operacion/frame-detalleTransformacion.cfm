<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Líneas">
	<form name="form1" method="post">
		<table border="0" width="100%">
		  <tr> 
			<td>
				<input type="hidden" name="ETid_" value="<cfoutput>#Form.ETid#</cfoutput>">
			</td>
		  </tr>
		  <tr>
			<td>
			
			<cf_dbfunction name="to_char" args="e.ETid" returnvariable ="ETid"> 
			<cf_dbfunction name="to_char" args="d.DTlinea" returnvariable ="DTlinea"> 
			<cf_dbfunction name="to_char" args="d.Aid" returnvariable ="Aid"> 
			<cf_dbfunction name="spart" args="d.DTobservacion,1,32" returnvariable ="DTobservacion"> 
			<cf_dbfunction name="concat" args="#preservesinglequotes(DTobservacion)#+ '...'" returnvariable="case1" delimiters = "+">
			<cf_dbfunction name="length" args="d.DTobservacion" returnvariable ="DTobservacion1"> 

			<cf_dbfunction name="length" args="a.Adescripcion" returnvariable ="Adescripcion1"> 
			<cf_dbfunction name="spart" args="a.Adescripcion,1,32" returnvariable ="Adescripcion"> 
			<cf_dbfunction name="concat" args="#preservesinglequotes(Adescripcion)#+ '...'" returnvariable="case2" delimiters = "+">

			<cf_dbfunction name="concat" args="'<b>' + a.Acodigo + '</b>'"  returnvariable="Acodigo" delimiters = "+">
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaRH"
			returnvariable="pListaRet">						
				<cfinvokeargument name="tabla" value="DTransformacion d, ETransformacion e, Articulos a"/>
				<cfinvokeargument name="columnas" value="
										#preservesinglequotes(ETid)# as ETid, 
										#preservesinglequotes(DTlinea)# as DTlinea, 
										#preservesinglequotes(Acodigo)# as Acodigo, 
										d.DTinvinicial, 
										d.DTrecepcion, 
										d.DTprodcons, 
										d.DTembarques, 
										d.DTconsumopropio, 
										d.DTperdidaganancia, 
										d.DTinvfinal,
										case when #preservesinglequotes(DTobservacion1)# >= 35 then #preservesinglequotes(case1)#
											 when #preservesinglequotes(DTobservacion1)# < 35 then d.DTobservacion end as DTobservacion,
										#preservesinglequotes(Aid)# as Aid, 
										d.DTfecha, 
										d.DTcostoU, 
										d.Ucodigo,
										case when #preservesinglequotes(Adescripcion1)# >= 35 then #preservesinglequotes(case2)#
											when #preservesinglequotes(Adescripcion1)# < 35 then a.Adescripcion end as Adescripcion"/>
				<cfinvokeargument name="desplegar" value="Acodigo, DTinvinicial, DTrecepcion, DTprodcons, DTembarques, DTconsumopropio, DTperdidaganancia, DTinvfinal"/>
				<cfinvokeargument name="etiquetas" value="Artículo, Inv/Inicial, Recepción, Prod/Cons, Embarques, Cons., Perd/Gan., Inv/Final"/>
				<cfinvokeargument name="formatos" value="V,M,M,M,M,M,M,M"/>
				<cfinvokeargument name="filtro" value="d.ETid = e.ETid 
										and e.Ecodigo=#session.Ecodigo# 
										and e.ETid=#Form.ETid#
										and e.Ecodigo = a.Ecodigo
										and d.Aid = a.Aid order by a.Acodigo
										"/>
				<cfinvokeargument name="align" value="left,right,right,right,right,right,right,right"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="irA" value="Transforma-form2.cfm"/>
				<cfinvokeargument name="formName" value="form1"/>
				<cfinvokeargument name="keys" value="ETid,DTlinea,DTinvinicial,DTrecepcion,DTprodcons,DTembarques,DTconsumopropio,DTperdidaganancia,DTinvfinal"/>
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="checkboxes" value="N">
				<cfinvokeargument name="incluyeForm" value="false">
				<cfinvokeargument name="showLink" value="false">
				<cfinvokeargument name="maxrows" value="0"/>
			</cfinvoke>
			</td>
		  </tr>
		</table>
	</form>
<cf_web_portlet_end>
