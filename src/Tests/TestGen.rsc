module Tests::TestGen

import lang::java::m3::AST;
import IO;
import PDG;
import ADT;
import ControlDependence::ControlFlow;

test bool testGen(){
	CF cf = getControlFlow(getMethodAST(|project://JavaTest/src/PDG/Sum.java|)[0]);
	map[int, set[str]] gens = getGens();
	map[int, set[str]] expectedGens = (10:{"i"},8:{"j"},7:{"sum"},5:{"j"},4:{"sum"},2:{"sum"},1:{"i"},0:{"n"});
	return (gens == expectedGens);
}