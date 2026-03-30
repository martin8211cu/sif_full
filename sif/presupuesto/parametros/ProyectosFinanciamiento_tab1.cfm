<form name="frmCtas">
	<table>
		<tr>
			<td>
				<strong>Descripcion:</strong>
			</td>
			<td>
				<input type="text" size="40" name="dsc" tabindex="1">
			</td>
		</tr>
		<tr>
			<td>
				<strong>Mascara Presupuesto:</strong>
			</td>
			<td>
				<cf_cajascuenta index="1" form="frmCtas" tabindex="1" objeto="msk" presupuesto="true">
			</td>
			<td>
				<input name="btnAdd_Ctas" value="+" tabindex="1" type="button" onclick="if (window.FrameFunction) FrameFunction();if(this.form.msk.value != '') Ctas_add(this.form.msk.value,this.form.dsc.value);"/>
			</td>
		</tr>
		
		<tr>
			<td colspan="3">
				<cfset LvarIMG = 'case when CPPFCesCF=1 then ''CF'' else ''<img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Cuenta" style="cursor:pointer" onclick="Ctas_del('''''' #cat# CPPFCmascara #cat# '''''');">'' end as IMG'>
				<cfset LvarTIPO = "
						CASE (SELECT min(CPTCtipo) from CPtipoCtas WHERE CPPid = prc.CPPid AND Ecodigo = prc.Ecodigo AND prc.CPPFCmascara like CPTCmascara AND CPTCtipo <> 'X')
							WHEN 'E' THEN 'E'
							WHEN 'C' THEN 'E'
							WHEN 'I' THEN 'I'
							ELSE CASE WHEN m.Ctipo IN ('A','G') THEN 'E' ELSE 'I' END
						END">
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cf_dbfunction name="OP_concat" returnVariable="CAT"> 
					<cf_dbfunction name="like" args="CPPFCmascara,m.Cmayor #CAT# '%'" returnVariable="LvarLike"> 
					<cfinvokeargument name="tabla" value="CPproyectosFinanciadosCtas prc inner join CtasMayor m on m.Ecodigo = prc.Ecodigo and #LvarLike#"/>
					<cfinvokeargument name="columnas" value="case when #LvarTIPO#='I' then 'MASCARAS DE INGRESOS' else 'MASCARAS DE EGRESOS' end as tipo, CPPFid, CPPFCdescripcion, CPPFCmascara, #LvarIMG#"/>
					<cfinvokeargument name="filtro" value="CPPFid=#form.CPPFid# and CPPid=#session.CPPid# order by 1,CPPFCdescripcion"/>
					<cfinvokeargument name="desplegar" value="CPPFCdescripcion, CPPFCmascara, IMG"/>
					<cfinvokeargument name="cortes" value="tipo"/>
					<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Mascara, "/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
					<cfinvokeargument name="align" value="left,left,center,center,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
					<cfinvokeargument name="irA" value="ProyectosFinanciamiento.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value=""/>
					<cfinvokeargument name="PageIndex" value="1"/>
					<cfinvokeargument name="MaxRows" value="0"/>
					<cfinvokeargument name="showLink" value="false"/>
				 </cfinvoke>
				 <script language="javascript">
					function Ctas_add(msk, dsc)
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnAdd_Cta&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>&msk=' + escape(msk) + '&dsc=' + escape(dsc);
					}
					function Ctas_del(msk)
					{
						location.href='ProyectosFinanciamiento_sql.cfm?btnDel_Cta&CPPFid=<cfoutput>#form.CPPFid#</cfoutput>&msk=' + escape(msk);
					}
				 </script>
				<script language="javascript1.2" type="text/javascript">
					function isDefined( object) {
						 return (typeof(eval(object)) == "undefined")? false: true;
					}
				
					//Dispara la funcion del iframe que retorna los datos de la cuenta
					function FrameFunction(){
						// RetornaCuenta2() es máscara completa, rellena con comodín
						if( isDefined(window.cuentasIframe1) )
							window.cuentasIframe1.RetornaCuenta2();
						if( isDefined(window.cuentasIframe2) )
							window.cuentasIframe2.RetornaCuenta2();
						if( isDefined(window.cuentasIframe3) )
							window.cuentasIframe3.RetornaCuenta2();
						if( isDefined(window.cuentasIframe4) )
							window.cuentasIframe4.RetornaCuenta2();
						if( isDefined(window.cuentasIframe5) )
							window.cuentasIframe5.RetornaCuenta2();
						if( isDefined(window.cuentasIframe6) )
							window.cuentasIframe6.RetornaCuenta2();
						if( isDefined(window.cuentasIframe7) )
							window.cuentasIframe7.RetornaCuenta2();
						if( isDefined(window.cuentasIframe8) )
							window.cuentasIframe8.RetornaCuenta2();
						if( isDefined(window.cuentasIframe9) )
							window.cuentasIframe9.RetornaCuenta2();
					}
				</script>
			</td>
		</tr>
	</table>
</form>
