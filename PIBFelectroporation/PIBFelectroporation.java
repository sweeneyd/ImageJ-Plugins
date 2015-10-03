import ij.plugin.PlugIn;
import org.python.util.PythonInterpreter;
public class PIBFelectroporation implements PlugIn {
  public void run(String arg) {
    // create a Python interpreter
    PythonInterpreter py = new PythonInterpreter();
    // execute the Python file containing the source code for this ImageJ plugin
    py.execfile("//Applications//Fiji.app/plugins//PIBFelectroporation//PIBFelectroporation.py");
  }
}
