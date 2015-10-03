import ij.plugin.PlugIn;
import org.python.util.PythonInterpreter;
public class Leica_NCR  implements PlugIn {
  public void run(String arg) {
    // create a Python interpreter
    PythonInterpreter py = new PythonInterpreter();
    // execute the Python file containing the source code for this ImageJ plugin
    py.execfile("plugins/Leica_NCR/Leica_NCR.py");
  }
}
