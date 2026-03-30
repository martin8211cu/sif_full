
<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
	}
	.leftline {
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-style: none;
		border-bottom-style: none;
		border-top-style: none;
	}	
	.rightline {
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-style: none;
		border-bottom-style: none;
		border-top-style: none;
	}		
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
	}
	.Lbottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;		
		border-top-style: none;
		border-right-style: none;
	}	
	.Rbottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;		
		border-top-style: none;
		border-left-style: none;
	}		
	.RLbottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;	
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;				
		border-top-style: none;
	}		
	.RLline {
		border-bottom-style: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;	
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;				
		border-top-style: none;
	}	
	.LbTottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;	
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;			
		border-right-style: none;
	}		
	.RLTbottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;	
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;			
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}		
</style><hr />


<cfquery name="rsBitacora" datasource="sifinterfaces">
		select Proceso, Fecha, Fecha_Correcto, Fecha_Error, Cantidad
        from LDSIF_Bitacora
        where Fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
</cfquery>

<!---<cfquery name="rsBitacora" datasource="sifinterfaces">
		select Proceso, Fecha, Fecha_Correcto, Fecha_Error, Cantidad
        from LDSIF_Bitacora
        where Fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
</cfquery>

--->
<!---                        insert into IE18 (ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, Falta, Usuario)
                  		values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#RsMaximo.Maximo#">,
                                <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsCab_Retiros_Caja.Ecodigo#">, 0
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha#">,
                                "Retiro de Caja del " & dateformat(Fecha, "dd/mm/yyyy"),
                                 null, "", getdate(), #session.USUCodigo#)
--->

<form action="/cfmx/sif/cg/MenuCG.cfm" method="post" name="sql">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="100%" bgcolor="gainsboro" align="center">
			<b><font size="2">Tablero de Indicadores de Interfaz</font></b>
		</td>
	</tr>
	
</table>
</form>

	<table width="100%" border="0" cellspacing="0" align="center">
		<tr>
			<td  class="topline" colspan="2" bgcolor="lightgrey">&nbsp;</td>
            <td width="18%"   align="right" nowrap bgcolor="lightgrey" class=" topline"><b><center><font size="2">Movimientos</font></center></b>		            </td>
			<td width="18%"   align="right" nowrap bgcolor="lightgrey" class="topline"><b><center><font size="2">Movimientos</font                ></center></b></td>
			<td width="18%"   align="right" nowrap bgcolor="lightgrey" class="topline"><b><center><font size="2">Movimientos</font></center></b                ></td>
			<td width="18%"   align="right" nowrap bgcolor="lightgrey" class="topline"><center><font size="2"><b>Ultimo Registro</b></font></center></td>
		</tr>
        			<tr>
						<td  nowrap class="Lbottomline" colspan="2" bgcolor="lightgrey"><b></b></td>
						<td nowrap class="Lbottomline" align="right" bgcolor="lightgrey"><b><center><font size="2">del Dia</font></center></b></td>
						<td nowrap class="Lbottomline" align="right" bgcolor="lightgrey"><b><center><font size="2">Pendientes de Procesar</font                ></center></b></td>
						<td nowrap class="Lbottomline" align="right" bgcolor="lightgrey"><b><center><font size="2">con Error</font></center></b                ></td>
                        <td nowrap class=" Rbottomline" align="right" bgcolor="lightgrey"><center><font size="2"><b>Procesado (Fecha/Hora)                </b></font></center></td>
					</tr>	
	<cfoutput query="rsBitacora">
					<tr>
						<td class="leftline" colspan="2" bgcolor="##FFFF99"></td>
						<td nowrap class="leftline" align="right" bgcolor="##33FF66">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="##33FF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="##33FFCC">&nbsp;</td>
                        <td nowrap class="RLline" align="right" bgcolor="##33FFFF">&nbsp;</td>
					</tr>	
					
				<tr>
					<td        class="leftline" colspan="2" bgcolor="##FFFF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="##000000"><b>INTERFAZ #Proceso# </b>                                                           </font></td>
					<td nowrap class="leftline" align="right" bgcolor="##33FF66"><font color="##000000">#Cantidad#
					</font>
                    </td>
					<td nowrap class="leftline" align="right" bgcolor="##33FF99"><font color="##000000">             35</font></td>
					<td nowrap class="leftline"   align="right" bgcolor="##33FFCC"><font color="##000000">             63</font></td>
                    <td nowrap class="RLline"   align="right" bgcolor="##33FFFF"><font color="##000000">#Fecha_Correcto#</font></td>
				</tr>
				
							<tr>s
								<td  class="Lbottomline" colspan="2" bgcolor="##FFFF99">&nbsp;</td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##33FF66" ><font style=" color:##FF0000">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##33FF99"><font style=" color:##FF0000">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="##33FFCC"><font style=" color:##FF0000">&nbsp;</font></td>
                                <td nowrap class="RLbottomline"   align="right" bgcolor="##33FFFF"><font color="##000000">             63</font></td>
							</tr>
	</cfoutput>
					<tr>
						<td  class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF66">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FFCC">&nbsp;</td>
                        <td nowrap class="RLline" align="right" bgcolor="#33FFFF">&nbsp;</td>
					</tr>	
					
				<tr>
					<td        class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#000000"><B>INTERFAZ 					CXP COMPRAS</B></font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF66"><font color="#000000">              5</font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF99"><font color="#000000">              5</font></td>
					<td nowrap class="leftline"   align="right" bgcolor="#33FFCC"><font color="#000000">              0</font></td>
                    <td nowrap class="RLline"   align="right" bgcolor="#33FFFF"><font color="#000000">             63</font></td>
				</tr>
				
							<tr>
								<td        class="Lbottomline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FF66" ><font style=" color:#FF0000"></font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FF99"><font style=" color:#FF0000"></font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FFCC"><font style=" color:#FF0000"></font></td>
                                <td nowrap class="RLbottomline"   align="right" bgcolor="#33FFFF"><font color="#000000"></font></td>
							</tr>
							
					<tr>
						<td  class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF66">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FFCC">&nbsp;</td>
                        <td nowrap class="RLline" align="right" bgcolor="#33FFFF">&nbsp;</td>
					</tr>	
					
				<tr>
					<td        class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#000000"><B>INTERFAZ MOVTOS. 						                               BANCARIOS</B></font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF66"><font color="#000000">              3</font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF99"><font color="#000000">              3</font></td>
					<td nowrap class="leftline"   align="right" bgcolor="#33FFCC"><font color="#000000">              3</font></td>
                    <td nowrap class="RLline"   align="right" bgcolor="#33FFFF"><font color="#000000">              3</font></td>
				</tr>
				
							<tr>
								<td  class="Lbottomline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FF66" ><font style=" color:#FF0000">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FF99"><font style=" color:#FF0000">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FFCC"><font style=" color:#FF0000">&nbsp;</font></td>
                                <td nowrap class="RLbottomline" align="right" bgcolor="#33FFFF"><font style=" color:#FF0000">&nbsp;</font></td>
							</tr>
							
					<tr>
						<td  class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF66">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FFCC">&nbsp;</td>
                        <td nowrap class="RLline" align="right" bgcolor="#33FFFF">&nbsp;</td>
					</tr>	
					
				<tr>
					<td        class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#000000">                                                                           <B>INTERFAZ CONTABLE</B></font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF66"><font color="#000000">             -18</font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF99"><font color="#000000">             -18</font></td>
					<td nowrap class="leftline"   align="right" bgcolor="#33FFCC"><font color="#000000">             12</font></td>
                    <td nowrap class="RLline"   align="right" bgcolor="#33FFFF"><font color="#000000">             12</font></td>
				</tr>
				
							<tr>
								<td  class="Lbottomline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FF66" ><font style=" color:#FF0000">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FF99"><font style=" color:#FF0000">&nbsp;</font></td>
								<td nowrap class="Lbottomline" align="right" bgcolor="#33FFCC"><font style=" color:#FF0000">&nbsp;</font></td>
                                <td nowrap class="RLbottomline" align="right" bgcolor="#33FFFF"><font style=" color:#FF0000">&nbsp;</font></td>
							</tr>
							
					<tr>
						<td  class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF66">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FF99">&nbsp;</td>
						<td nowrap class="leftline" align="right" bgcolor="#33FFCC">&nbsp;</td>
                        <td nowrap class="RLline" align="right" bgcolor="#33FFFF">&nbsp;</td>
					</tr>	
					
				<tr>
					<td        class="leftline" colspan="2" bgcolor="#FFFF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#000000">                                                                                </font></td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF66">&nbsp;</td>
					<td nowrap class="leftline" align="right" bgcolor="#33FF99">&nbsp;</td>
					<td nowrap class="leftline"   align="right" bgcolor="#33FFCC">&nbsp;</td>
                    <td nowrap class="RLline"   align="right" bgcolor="#33FFFF">&nbsp;</td>
				</tr>
				
					<tr>
						<td class="Lbottomline" bgcolor="#FFFF99" colspan="2">&nbsp;</td>
						<td nowrap class="Lbottomline" align="right" bgcolor="#33FF66"><font style=" color:#FF0000">&nbsp;</font></td>
                        <td nowrap class="Lbottomline" align="right" bgcolor="#33FF99"><font style=" color:#FF0000">&nbsp;</font></td>																							                        <td nowrap class="Lbottomline" align="right" bgcolor="#33FFCC"><font style=" color:#FF0000">&nbsp;</font></td>
                        <td nowrap class="RLbottomline" align="right" bgcolor="#33FFFF"><font style=" color:#FF0000">&nbsp;</font></td>
					</tr>
					
	</table>	
	
