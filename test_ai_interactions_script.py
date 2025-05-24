#!/usr/bin/env python3
"""
Unit tests for AI Interactions Log Generator Script
"""

import unittest
import tempfile
import shutil
from pathlib import Path
from datetime import datetime
from unittest.mock import patch, MagicMock

# Import the module we're testing
from make_ai_interactions_script import AIInteractionsLogger


class TestAIInteractionsLogger(unittest.TestCase):
    """Test cases for AIInteractionsLogger class."""
    
    def setUp(self):
        """Set up test fixtures before each test method."""
        # Create a temporary directory for testing
        self.test_dir = tempfile.mkdtemp()
        self.logger = AIInteractionsLogger(self.test_dir)
        
    def tearDown(self):
        """Clean up after each test method."""
        # Remove the temporary directory
        shutil.rmtree(self.test_dir)
    
    def test_init(self):
        """Test logger initialization."""
        self.assertEqual(self.logger.project_root, Path(self.test_dir))
        self.assertEqual(
            self.logger.template_file, 
            Path(self.test_dir) / "ai_interactions_template.md"
        )
        self.assertEqual(
            self.logger.example_file,
            Path(self.test_dir) / "ai_interactions_example.md"
        )
    
    @patch('make_ai_interactions_script.datetime')
    def test_create_log_file(self, mock_datetime):
        """Test creating a new log file."""
        # Mock datetime
        mock_datetime.now.return_value.strftime.side_effect = [
            "23-May-2025",  # date format
            "11:35 AM"      # time format
        ]
        
        # Test creating log file
        branch_name = "5_flutter_integration"
        session_title = "Flutter Setup"
        
        log_path = self.logger.create_log_file(branch_name, session_title)
        
        # Verify file was created
        expected_filename = "5_ai_interactions_log.md"
        expected_path = str(Path(self.test_dir) / expected_filename)
        self.assertEqual(log_path, expected_path)
        self.assertTrue(Path(log_path).exists())
        
        # Verify content
        with open(log_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        self.assertIn("Branch 5", content)
        self.assertIn("5_flutter_integration", content)
        self.assertIn("Flutter Setup", content)
        self.assertIn("23-May-2025", content)
        self.assertIn("11:35 AM", content)
    
    def test_create_log_file_simple_branch_name(self):
        """Test creating log file with simple branch name (no underscore)."""
        branch_name = "main"
        log_path = self.logger.create_log_file(branch_name)
        
        expected_filename = "main_ai_interactions_log.md"
        expected_path = str(Path(self.test_dir) / expected_filename)
        self.assertEqual(log_path, expected_path)
    
    def test_add_session(self):
        """Test adding a session to existing log file."""
        # First create a log file
        log_path = self.logger.create_log_file("test_branch")
        
        # Prepare session data
        session_data = {
            'session_number': 2,
            'title': 'Test Session',
            'date': '24-May-2025',
            'time': '10:00 AM',
            'assistant': 'Claude 4',
            'duration': '30 min',
            'prompts': 'Test prompt',
            'actions': 'Test actions',
            'challenges': 'Test challenges',
            'status': 'Complete',
            'next_steps': 'Next steps',
            'code_changes': 'Test changes',
            'commands': 'test command'
        }
        
        # Add session
        self.logger.add_session(log_path, session_data)
        
        # Verify session was added
        with open(log_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        self.assertIn("Session 2: Test Session", content)
        self.assertIn("24-May-2025", content)
        self.assertIn("Claude 4", content)
        self.assertIn("Test prompt", content)
    
    def test_create_template_files(self):
        """Test creating template and example files."""
        # Initially files shouldn't exist
        self.assertFalse(self.logger.template_file.exists())
        self.assertFalse(self.logger.example_file.exists())
        
        # Create template files
        self.logger.create_template_files()
        
        # Verify files were created
        self.assertTrue(self.logger.template_file.exists())
        self.assertTrue(self.logger.example_file.exists())
        
        # Verify template content
        template_content = self.logger.template_file.read_text(encoding='utf-8')
        self.assertIn("AI Interactions Log - Branch {branch_prefix}", template_content)
        
        # Verify example content
        example_content = self.logger.example_file.read_text(encoding='utf-8')
        self.assertIn("AI Interactions Log - Branch 1", example_content)
    
    def test_create_template_files_existing(self):
        """Test that existing template files are not overwritten."""
        # Create files first
        self.logger.template_file.write_text("existing template", encoding='utf-8')
        self.logger.example_file.write_text("existing example", encoding='utf-8')
        
        # Try to create template files again
        self.logger.create_template_files()
        
        # Verify original content is preserved
        self.assertEqual(
            self.logger.template_file.read_text(encoding='utf-8'),
            "existing template"
        )
        self.assertEqual(
            self.logger.example_file.read_text(encoding='utf-8'),
            "existing example"
        )
    
    def test_load_template_with_existing_file(self):
        """Test loading template when template file exists."""
        # Create a template file
        template_content = "Custom template content"
        self.logger.template_file.write_text(template_content, encoding='utf-8')
        
        # Load template
        loaded_content = self.logger._load_template()
        
        self.assertEqual(loaded_content, template_content)
    
    def test_load_template_without_existing_file(self):
        """Test loading template when template file doesn't exist."""
        # Ensure template file doesn't exist
        self.assertFalse(self.logger.template_file.exists())
        
        # Load template (should return default)
        loaded_content = self.logger._load_template()
        
        # Should contain default template markers
        self.assertIn("AI Interactions Log - Branch {branch_prefix}", loaded_content)
    
    def test_session_template(self):
        """Test session template generation."""
        template = self.logger._get_session_template()
        
        # Verify template contains expected placeholders
        expected_placeholders = [
            '{session_number}', '{title}', '{date}', '{time}',
            '{assistant}', '{duration}', '{prompts}', '{actions}',
            '{challenges}', '{status}', '{next_steps}',
            '{code_changes}', '{commands}'
        ]
        
        for placeholder in expected_placeholders:
            self.assertIn(placeholder, template)


class TestMainFunction(unittest.TestCase):
    """Test cases for main function and command line interface."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.test_dir = tempfile.mkdtemp()
        
    def tearDown(self):
        """Clean up after tests."""
        shutil.rmtree(self.test_dir)
    
    @patch('sys.argv')
    @patch('make_ai_interactions_script.AIInteractionsLogger')
    def test_main_create_command(self, mock_logger_class, mock_argv):
        """Test main function with create command."""
        # Setup mocks
        mock_argv.__getitem__.side_effect = [
            'script.py',  # sys.argv[0]
            'create',     # sys.argv[1] 
            'test_branch', # sys.argv[2]
            'Test Session' # sys.argv[3]
        ]
        mock_argv.__len__.return_value = 4
        
        mock_logger = MagicMock()
        mock_logger_class.return_value = mock_logger
        mock_logger.create_log_file.return_value = "test_log.md"
        
        # Import and run main
        from make_ai_interactions_script import main
        
        # Capture stdout to avoid printing during tests
        with patch('builtins.print'):
            main()
        
        # Verify logger was called correctly
        mock_logger.create_log_file.assert_called_once_with('test_branch', 'Test Session')
    
    @patch('sys.argv')
    @patch('make_ai_interactions_script.AIInteractionsLogger')
    def test_main_setup_command(self, mock_logger_class, mock_argv):
        """Test main function with setup command."""
        # Setup mocks
        mock_argv.__getitem__.side_effect = ['script.py', 'setup']
        mock_argv.__len__.return_value = 2
        
        mock_logger = MagicMock()
        mock_logger_class.return_value = mock_logger
        
        # Import and run main
        from make_ai_interactions_script import main
        
        # Capture stdout to avoid printing during tests
        with patch('builtins.print'):
            main()
        
        # Verify setup was called
        mock_logger.create_template_files.assert_called_once()
    
    @patch('sys.argv')
    def test_main_no_args(self, mock_argv):
        """Test main function with no arguments."""
        mock_argv.__len__.return_value = 1
        
        from make_ai_interactions_script import main
        
        # Should print usage without error
        with patch('builtins.print') as mock_print:
            main()
        
        # Verify usage message was printed
        mock_print.assert_called()
        args, _ = mock_print.call_args_list[0]
        self.assertIn("Usage:", args[0])


class TestIntegration(unittest.TestCase):
    """Integration tests that test the full workflow."""
    
    def setUp(self):
        """Set up test environment."""
        self.test_dir = tempfile.mkdtemp()
        self.logger = AIInteractionsLogger(self.test_dir)
    
    def tearDown(self):
        """Clean up test environment."""
        shutil.rmtree(self.test_dir)
    
    def test_full_workflow(self):
        """Test complete workflow from creation to session addition."""
        # Create initial log file
        branch_name = "feature_branch_123"
        log_path = self.logger.create_log_file(branch_name, "Initial Setup")
        
        # Verify file exists and has correct name
        self.assertTrue(Path(log_path).exists())
        self.assertIn("feature_ai_interactions_log.md", log_path)
        
        # Add a session
        session1_data = {
            'session_number': 2,
            'title': 'Bug Fix Session',
            'prompts': 'Fix the import error',
            'actions': 'Updated import statements',
            'status': '✅ Complete'
        }
        
        self.logger.add_session(log_path, session1_data)
        
        # Add another session
        session2_data = {
            'session_number': 3,
            'title': 'Testing Session',
            'prompts': 'Create unit tests',
            'actions': 'Added test cases',
            'status': '⏳ In Progress'
        }
        
        self.logger.add_session(log_path, session2_data)
        
        # Verify final content
        with open(log_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Should contain initial session
        self.assertIn("Session 1: Initial Setup", content)
        
        # Should contain added sessions
        self.assertIn("Session 2: Bug Fix Session", content)
        self.assertIn("Session 3: Testing Session", content)
        self.assertIn("Fix the import error", content)
        self.assertIn("Create unit tests", content)
        self.assertIn("✅ Complete", content)
        self.assertIn("⏳ In Progress", content)


if __name__ == '__main__':
    # Run the tests
    unittest.main(verbosity=2)